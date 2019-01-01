+++
menutitle = "Deploy master node"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Deploy master Node (k8s-master-01)

Initialize kubeadm with pod IP range
```shell
$ sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.56.201
```

Configure `kubectl`
```shell
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Verify master node status
```shell
$ kubectl cluster-info
```

Output will be like below

```console
Kubernetes master is running at https://192.168.56.201:6443
KubeDNS is running at https://192.168.56.201:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```
