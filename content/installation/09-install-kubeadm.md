+++
menutitle = "Install kubeadm"
date = 2018-12-29T17:15:52Z
weight = 13
chapter = false
pre = "<b>- </b>"
+++

# Install kubelet , kubeadm and  kubectl

Verify the MAC address and product_uuid are unique for every node

- `ip link` or `ifconfig -a`
- `sudo cat /sys/class/dmi/id/product_uuid`

Download pre-requisites
```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```

Add gpg key for apt
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |sudo apt-key add -
```

Add apt repository
```
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

Install kubelet , kubeadm and  kubectl
```
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

Repeat the same steps on worker node
