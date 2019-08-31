+++
menutitle = "TLS bootstrapping with bootstrap-token"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# TLS bootstrapping with bootstrap-token

### Introduction

Bootstrap tokens are a simple bearer token that is meant to be used when creating new clusters or joining new nodes to an existing cluster. It was built to support kubeadm, but can be used in other contexts for users that wish to start clusters without kubeadm. It is also built to work, via RBAC policy, with the Kubelet TLS Bootstrapping system.

You can read more about bootstrap tokens [here](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/)

Bootstrap Tokens take the form of abcdef.0123456789abcdef.
More formally, they must match the regular expression [a-z0-9]{6}\.[a-z0-9]{16}

In this session , we will join a worker node to the cluster using bootstrap tokens.

Kubeadm uses bootstrap token to join a node to cluster.

Implementation Flow of Kubeadm is as follows.


- kubeadm connects to the API server address specified over TLS. As we don't yet have a root certificate to trust, this is an insecure connection and the server certificate is not validated. kubeadm provides no authentication credentials at all.

Implementation note: the API server doesn't have to expose a new and special insecure HTTP endpoint.

(D)DoS concern: Before this flow is secure to use/enable publicly (when not bootstrapping), the API Server must support rate-limiting. There are a couple of ways rate-limiting can be implemented to work for this use-case, but defining the rate-limiting flow in detail here is out of scope. One simple idea is limiting unauthenticated requests to come from clients in RFC1918 ranges.

- kubeadm requests a ConfigMap containing the kubeconfig file defined above.
This ConfigMap exists at a well known URL: https://<server>/api/v1/namespaces/kube-public/configmaps/cluster-info

This ConfigMap is really public. Users don't need to authenticate to read this ConfigMap. In fact, the client MUST NOT use a bearer token here as we don't trust this endpoint yet.

- The API server returns the ConfigMap with the kubeconfig contents as normal
Extra data items on that ConfigMap contains JWS signatures. kubeadm finds the correct signature based on the token-id part of the token. (Described below).

- kubeadm verifies the JWS and can now trust the server. Further communication is simpler as the CA certificate in the kubeconfig file can be trusted.


You may read more about the proposal [here](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/cluster-lifecycle/bootstrap-discovery.md)

### API server
To support bootstrap token based discovery and to join nodes to cluster ; we need to make sure below flags are in place on API server.

```ruby
--client-ca-file=/var/lib/kubernetes/ca.pem
--enable-bootstrap-token-auth=true
```

If not present , then add these flags to `/etc/systemd/system/kube-apiserver.service` unit file.

### Controller

make sure below flags are in place on kube-controller-manager .

```ruby
--controllers=*,bootstrapsigner,tokencleaner
--experimental-cluster-signing-duration=8760h0m0s
--cluster-signing-cert-file=/var/lib/kubernetes/ca.pem
--cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem
```

If not present , then add these flags to `/etc/systemd/system/kube-controller-manager.service` unit file.

- Reload and restart API server and Controller unit files

```shell
{
  sudo systemctl daemon-reload
  sudo systemctl restart kube-apiserver.service
  sudo systemctl restart kube-controller-manager.service
}
```
### RBAC Permission to enable certificate signign

- To allow kubelet to create CSR

```yaml
cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: create-csrs-for-bootstrapping
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:node-bootstrapper
  apiGroup: rbac.authorization.k8s.io
EOF
```

- CSR auto signing for bootstrapper

```yaml
cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-csrs-for-group
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:nodeclient
  apiGroup: rbac.authorization.k8s.io
EOF
```

- Certificates self renewal

```yaml
cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-renewals-for-nodes
subjects:
- kind: Group
  name: system:nodes
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
  apiGroup: rbac.authorization.k8s.io
EOF
```

### Create bootstrap token

```shell
$ echo $(openssl rand -hex 3).$(openssl rand -hex 8)
```
>Output

```console
80a6ee.fd219151288b08d8
```

```shell
$ vi bootstrap-token.yaml
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  # Name MUST be of form "bootstrap-token-<token id>"
  name: bootstrap-token-80a6ee
  namespace: kube-system

# Type MUST be 'bootstrap.kubernetes.io/token'
type: bootstrap.kubernetes.io/token
stringData:
  # Human readable description. Optional.
  description: "The default bootstrap token."

  # Token ID and secret. Required.
  token-id: 80a6ee
  token-secret: fd219151288b08d8

  # Expiration. Optional.
  expiration: 2019-12-05T12:00:00Z

  # Allowed usages.
  usage-bootstrap-authentication: "true"
  usage-bootstrap-signing: "true"

  # Extra groups to authenticate the token as. Must start with "system:bootstrappers:"
  auth-extra-groups: system:bootstrappers:worker,system:bootstrappers:ingress
```

```shell
$ kubectl create -f bootstrap-token.yaml
```

Create cluster-info for clients which will be downloaded if needed by client

```shell
KUBERNETES_MASTER=$(awk '/master/{print $1;exit}' /etc/hosts)
```

```shell
$ kubectl config set-cluster bootstrap \
  --kubeconfig=bootstrap-kubeconfig-public  \
  --server=https://${KUBERNETES_MASTER}:6443 \
  --certificate-authority=ca.pem \
  --embed-certs=true
```

```shell
$ kubectl -n kube-public create configmap cluster-info \
  --from-file=kubeconfig=bootstrap-kubeconfig-public
```

```shell
$ kubectl -n kube-public get configmap cluster-info -o yaml
```
- RBAC to allow anonymous users to access the `cluster-info` ConfigMap

```shell
$ kubectl create role anonymous-for-cluster-info --resource=configmaps --resource-name=cluster-info --namespace=kube-public --verb=get,list,watch
$ kubectl create rolebinding anonymous-for-cluster-info-binding --role=anonymous-for-cluster-info --user=system:anonymous --namespace=kube-public
```

Create bootstrap-kubeconfig for worker nodes

```shell
$ kubectl config set-cluster bootstrap \
  --kubeconfig=bootstrap-kubeconfig \
  --server=https://${KUBERNETES_MASTER}:6443 \
  --certificate-authority=ca.pem \
  --embed-certs=true
```

```shell
$ kubectl config set-credentials kubelet-bootstrap \
  --kubeconfig=bootstrap-kubeconfig \
  --token=80a6ee.fd219151288b08d8
```

```shell
$ kubectl config set-context bootstrap \
  --kubeconfig=bootstrap-kubeconfig \
  --user=kubelet-bootstrap \
  --cluster=bootstrap
```

```shell
$ kubectl config --kubeconfig=bootstrap-kubeconfig use-context bootstrap
```

Copy the bootstrap-kubeconfig to worker node and then execute below steps from worker node.



### Kubelet configuration

- Turnoff swap

```shell
$ sudo swapoff /dev/dm-1 ##<--- select appropriate swap device based on your OS config
```
- Install and start [docker service](/02-installation/04-docker-install/)

- Once docker is installed , execute below steps to make docker ready for `kubelet` integration.

```shell
$ sudo vi /lib/systemd/system/docker.service
```

- Disable iptables, default bridge network and masquerading on docker

```ruby
ExecStart=/usr/bin/dockerd -H fd:// --bridge=none --iptables=false --ip-masq=false
```

- Cleanup all docker specific networking from worker nodes

```shell
$ sudo iptables -t nat -F
$ sudo ip link set docker0 down
$ sudo ip link delete docker0
```
- Restart docker

```shell
$ sudo systemctl restart docker
```

- Move bootstrap config file to `/var/lib/kubelet/`

```shell
$ mkdir /var/lib/kubelet/
$ sudo mv bootstrap-kubeconfig /var/lib/kubelet/  
```

- Create a systemd untit file and add necessary flags.

```shell
$ cat <<EOF |sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \
 --bootstrap-kubeconfig=/var/lib/kubelet/bootstrap-kubeconfig \
 --cert-dir=/var/lib/kubelet/ \
 --kubeconfig=/var/lib/kubelet/kubeconfig \
 --rotate-certificates=true \
 --runtime-cgroups=/systemd/system.slice \
 --kubelet-cgroups=/systemd/system.slice
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

- Reload and start the kubelet service

```shell
$ sudo systemctl daemon-reload
$ sudo systemctl start kubelet
```

Now execute kubectl get nodes and see if the node is listed there.

You may configure `kube-proxy` as a DaemonSet so that it will automatically start after node registration completion.