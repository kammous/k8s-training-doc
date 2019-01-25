+++
menutitle = "Add worker node"
date = 2018-12-29T17:15:52Z
weight = 15
chapter = false
pre = "<b>- </b>"
+++

# Add worker node to cluster

- Get discovery secret from Master node.

```shell
$ echo sha256:$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)
```

- Get node join token from Master node.

```shell
$ kubeadm token list |grep bootstra |awk '{print $1}'
```

- Execute kubeadm command to add the Worker to cluster

```shell
$ sudo kubeadm join 192.168.56.201:6443 --token <token> --discovery-token-ca-cert-hash <discovery hash>
```

- Verify system Pod status

```shell
$ kubectl get pods -n kube-system |nl
```

- Output

```yaml
 1  NAME                                    READY   STATUS    RESTARTS   AGE
 2  calico-node-2pwv9                       2/2     Running   0          20m
 3  calico-node-hwnfh                       2/2     Running   0          19m
 4  coredns-86c58d9df4-d9q2l                1/1     Running   0          21m
 5  coredns-86c58d9df4-rwv7r                1/1     Running   0          21m
 6  etcd-k8s-master-01                      1/1     Running   0          20m
 7  kube-apiserver-k8s-master-01            1/1     Running   0          20m
 8  kube-controller-manager-k8s-master-01   1/1     Running   0          20m
 9  kube-proxy-m6m9n                        1/1     Running   0          21m
10  kube-proxy-shwgp                        1/1     Running   0          19m
11  kube-scheduler-k8s-master-01            1/1     Running   0          20m
```
