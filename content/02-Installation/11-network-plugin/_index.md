+++
menutitle = "Deploy Calico"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Deploy Network Plugin - Calico

- Apply RBAC rules (More about RBAC will discuss later)

```shell
$ kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
```

- Download Calico deployment YAML

```shell
$ wget https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```

- Edit `CALICO_IPV4POOL_CIDR` value to `10.10.0.0/16`

```yaml
- name: CALICO_IPV4POOL_CIDR
  value: "10.10.0.0/16"
```

- Add `name: IP_AUTODETECTION_METHOD` & `value: "can-reach=192.168.56.1"` (This IP should be the host only network ip on your laptop)

```yaml
...
image: quay.io/calico/node:v3.3.2
env:
  - name: IP_AUTODETECTION_METHOD
    value: "can-reach=192.168.56.1"
...
```

- Apply Deployment

```shell
$ kubectl apply -f calico.yaml
```

- Make sure the `READY` status should show same value on left and right side of `/` and  `Pod` `STATUS` should be `Running`

```shel
$ kubectl get pods -n kube-system |nl
```

```yaml
1  NAME                                    READY   STATUS    RESTARTS   AGE
2  calico-node-2pwv9                       2/2     Running   0          20m
3  coredns-86c58d9df4-d9q2l                1/1     Running   0          21m
4  coredns-86c58d9df4-rwv7r                1/1     Running   0          21m
5  etcd-k8s-master-01                      1/1     Running   0          20m
6  kube-apiserver-k8s-master-01            1/1     Running   0          20m
7  kube-controller-manager-k8s-master-01   1/1     Running   0          20m
8  kube-proxy-m6m9n                        1/1     Running   0          21m
9  kube-scheduler-k8s-master-01            1/1     Running   0          20m
```

{{% notice tip %}}
Contact the Trainer if the output is not the expected one after few minutes (~3-4mins).
{{% /notice %}}
