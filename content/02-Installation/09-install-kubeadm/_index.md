+++
menutitle = "Install kubeadm"
date = 2018-12-29T17:15:52Z
weight = 13
chapter = false
pre = "<b>- </b>"
+++

# Install kubelet , kubeadm and  kubectl
{{% notice note %}}
 Verify the MAC address and product_uuid are unique for every node
(`ip link` or `ifconfig -a` and `sudo cat /sys/class/dmi/id/product_uuid`)
{{% /notice %}}

- Download pre-requisites

```shell
$ sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```

- Add gpg key for apt

```shell
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |sudo apt-key add -
```

- Add apt repository

```bash
$ cat <<EOF |sudo tee -a /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

- Install kubelet , kubeadm and  kubectl

```shell
$ sudo apt-get update
$ sudo apt-get install -y kubelet kubeadm kubectl
$ sudo apt-mark hold kubelet kubeadm kubectl
```

Repeat the same steps on worker node
