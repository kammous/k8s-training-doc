+++
menutitle = "TLS bootstrapping with tocken file"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# TLS bootstrapping with bootstrap-token

### Workflow

![TLS Bootstrap](tls-boot-strapping.png?classes=shadow)


Create a Token

```
$ head -c 16 /dev/urandom | od -An -t x | tr -d ' '
```

>Output

```
12c12e7eb3a9c3f9255bb74529c6768e
```

```
$ echo 12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,\"system:bootstrappers\" |sudo tee -a /etc/kubernetes/config/bootstrap-token.conf
```

```
12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,"system:bootstrappers"
```
Create a token auth file

```
$ cat /etc/kubernetes/config/bootstrap-token.conf
```

```
12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,"system:bootstrappers"
```

Add below flags to API server

```
--enable-bootstrap-token-auth=true \
--token-auth-file=/etc/kubernetes/config/bootstrap-token.conf \
```


Add RBAC for Node TLS bootstrapping and certificate auto renewal.

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

Create a bootstrap-kubeconfig which can be used by kubelet

```shell
TOKEN=$(awk -F "," '{print $1}' /etc/kubernetes/config/bootstrap-token.conf)
KUBERNETES_PUBLIC_ADDRESS=$(grep master /etc/hosts |awk '{print $1}')
```

```shell
kubectl config --kubeconfig=bootstrap-kubeconfig set-cluster bootstrap --embed-certs=true --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 --certificate-authority=ca.pem
```

```shell
kubectl config --kubeconfig=bootstrap-kubeconfig set-credentials kubelet-bootstrap --token=${TOKEN}
```

```shell
kubectl config --kubeconfig=bootstrap-kubeconfig set-context bootstrap --user=kubelet-bootstrap --cluster=bootstrap
````

```shell
kubectl config --kubeconfig=bootstrap-kubeconfig use-context bootstrap
```

Copy bootstrap-kubeconfig to worker node

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
