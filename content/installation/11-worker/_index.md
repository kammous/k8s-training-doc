+++
menutitle = "Add worker node"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Add worker node to cluster

#### Get discovery secret from Master node.
```shell
$ echo sha256:$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)
```

#### Get node join token from Master node.
```shell
$ kubeadm token list |grep bootstra |awk '{print $1}'
```

#### Execute kubeadm command to add the Worker to cluster
```shell
$ sudo kubeadm join 192.168.56.201:6443 --token <token> --discovery-token-ca-cert-hash <discovery hash>
```

#### Verify node list from Master node
```shell
$ kubectl get nodes
NAME            STATUS     ROLES    AGE   VERSION
k8s-master-01   NotReady   master   18m   v1.13.1
k8s-worker-01   NotReady   <none>   17s   v1.13.1
```
