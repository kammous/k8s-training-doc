+++
menutitle = "Deploy Calico"
date = 2018-12-29T17:15:52Z
weight = 14
chapter = false
pre = "<b>- </b>"
+++

# Deploy Network Plugin - Calico

#### Apply RBAC rules (More about RBAC will discuss later)
```shell
$ kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
```

#### Download Calico deployment YAML
```
wget https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```

#### Edit CALICO_IPV4POOL_CIDR value to 192.168.0.0/24 (To avoid node IP range conflict)
Change
```
- name: CALICO_IPV4POOL_CIDR
  value: "192.168.0.0/24"
```

#### Add `name: IP_AUTODETECTION_METHOD` & `value: "can-reach=192.168.56.1"` (This IP should be reachable)
```
...
image: quay.io/calico/node:v3.3.2
env:
  - name: IP_AUTODETECTION_METHOD
    value: "can-reach=192.168.56.1"
...
```

#### Apply Deployment
```shell
$ kubectl apply -f calico.yaml
```

#### Watch node `STATUS` changes from `NotReady` to `Ready`
```shell
$ kubectl get node --watch
```

#### Press Ctrl+c once you get below output
```console
NAME            STATUS     ROLES    AGE     VERSION
k8s-master-01   Ready      master   27m     v1.13.1
k8s-worker-01   Ready      <none>   9m25s   v1.13.1
```

Note: If the Node status is not changing to `Ready` status , contact trainer.
