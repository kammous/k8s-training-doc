+++
menutitle = "Worker Plane Setup"
date = 2018-12-29T17:15:52Z
weight = 9
chapter = false
pre = "<b>- </b>"
+++

# Bootstrapping worker nodes

In this lab , we will bootstrap three worker nodes.
The following components will be installed on each node.

- Docker
- Kubelet
- Kube-proxy
- Calico Network Plugin
- CoreDNS


### Docker

Instructions are [here](/02-installation/04-docker-install)

Once docker is installed , execute below steps to make docker ready for `kubelet` integration.

```shell
$ vi /lib/systemd/system/docker.service
```

Disable iptables, default bridge network and masquerading on docker

```ruby
ExecStart=/usr/bin/dockerd -H fd:// --bridge=none --iptables=false --ip-masq=false
```

Cleanup all docker specific networking from worker nodes

```shell
$ sudo iptables -t nat -F
$ sudo ip link set docker0 down
$ sudo ip link delete docker0
```

Reload and then stop docker (we will start it later)

```shell
$ sudo systemctl daemon-reload
$ sudo systemctl stop docker
```

### Download and configure Prerequisites

Install few binaries which are needed for proper networking

```shell
$ {
  sudo apt-get update
  sudo apt-get -y install socat conntrack ipset
}
```

Download `kuberctl, kube-proxy and kubelet`

```shell
$ wget -q --show-progress --https-only --timestamping \
https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubelet
```

Create needed directories

```shell
$ sudo mkdir -p \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes
```

Provide execution permission and move to one of the shell $PATH

```shell
$ chmod +x kubectl kube-proxy kubelet
$ sudo mv kubectl kube-proxy kubelet /usr/local/bin/
```

### Kubelet configuration

Move certificates and configuration files to the path created earlier

```shell
$ {
  sudo mv ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
  sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
  sudo mv ca.pem /var/lib/kubernetes/
}
```

Create `kubelet` configuration

```shell
$ cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "172.168.0.2"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/resolvconf/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
EOF
```

Create systemd unit file for `kubelet`

```shell
$ cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

###  Kubernetes Proxy configuration

```shell
$ sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
```

```shell
$ cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.10.0.0/16"
EOF
```

```shell
$ cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

### Service startup

```shell
$ {
  sudo systemctl daemon-reload
  sudo systemctl enable docker kubelet kube-proxy
  sudo systemctl start docker kubelet kube-proxy
}
```

### Calico CNI deployment

Download deployment yaml.

```shell
$ curl \
https://docs.projectcalico.org/v3.5/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml \
-O
```
Modify Pod cidr pool as below

```shell
$ vi calico.yaml
```

```yaml
- name: CALICO_IPV4POOL_CIDR
  value: "10.10.0.0/16"
```

Create deployment

```
$ kubectl apply -f calico.yaml
```
### CoreDNS deployment

Download and apply prebuilt CoreDNS yaml

```
$ kubectl apply -f https://raw.githubusercontent.com/ansilh/kubernetes-the-hardway-virtualbox/master/config/coredns.yaml
```

### Verification

```shell
$ kubectl cluster-info
```

>**Output**

```java
Kubernetes master is running at http://localhost:8080
CoreDNS is running at http://localhost:8080/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

```shell
$ kubectl get componentstatus
```
>**Output**

```yaml
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   {"health":"true"}
etcd-2               Healthy   {"health":"true"}
etcd-1               Healthy   {"health":"true"}
```

```shell
$ kubectl get nodes
```

>**Output**

```yaml
NAME               STATUS   ROLES    AGE   VERSION
k8s-worker-ah-01   Ready    <none>   47m   v1.13.0
k8s-worker-ah-02   Ready    <none>   47m   v1.13.0
k8s-worker-ah-03   Ready    <none>   47m   v1.13.0
```

```shell
$ kubectl get pods -n kube-system
```

>**Output**

```yaml
NAME                       READY   STATUS    RESTARTS   AGE
calico-node-8ztcq          1/1     Running   0          21m
calico-node-hb7gt          1/1     Running   0          21m
calico-node-mjkfn          1/1     Running   0          21m
coredns-69cbb76ff8-kw8ls   1/1     Running   0          20m
coredns-69cbb76ff8-vb7rz   1/1     Running   0          20m
```
