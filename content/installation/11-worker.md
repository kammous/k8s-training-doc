+++
menutitle = "Add worker node"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Add worker node to cluster

Execute kubeadm command to add the node to cluster
```
sudo kubeadm join 192.168.56.201:6443 --token 7b9521.7o0nbgmeaic6qg1s --discovery-token-ca-cert-hash sha256:1e69a7ca916b75847cce431fd1954b4039cc3877d185e8a23707735c344df96b
```
