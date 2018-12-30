+++
menutitle = "Deploy master node"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Deploy master Node (k8s-master-01)

Initialize kubeadm with pod IP range
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.56.201
```

Configure `kubectl`
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Note down token to join next node
```
sudo kubeadm join 192.168.56.201:6443 --token 7b9521.7o0nbgmeaic6qg1s --discovery-token-ca-cert-hash sha256:1e69a7ca916b75847cce431fd1954b4039cc3877d185e8a23707735c344df96b
```
