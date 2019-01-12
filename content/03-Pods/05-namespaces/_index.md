+++
menutitle = "Namespaces"
date = 2018-12-29T17:15:52Z
weight = 5
chapter = false
pre = "<b>- </b>"
+++

# Namespaces

#### What is a namespace
We have see namespaces in Linux , which ideally isolates objects and here also the concept is same but serves a different purpose.
Suppose you have two departments in you organization and both departments have application which needs more fine grained control.
We can use namespaces to separate the workload of each departments.

By default kubernetes will have three namespace

#### List namespace
```shell
$ kubectl get ns
NAME          STATUS   AGE
default       Active   39h
kube-public   Active   39h
kube-system   Active   39h
```

default : All Pods that we manually create will go to this namespace (There are ways to change it , but for now that is what it is).
kube-public : All common workloads can be assigned to this namespace . Most of the time no-one use it.
kube-system : Kubernetes specific Pods will be running on this namespace

#### List Pods in kube-system namespace
```shell
$ kubectl get pods --namespace=kube-system
NAME                                    READY   STATUS    RESTARTS   AGE
calico-node-n99tb                       2/2     Running   0          38h
calico-node-nkcrd                       2/2     Running   0          38h
coredns-86c58d9df4-4c22l                1/1     Running   0          39h
coredns-86c58d9df4-b49c2                1/1     Running   0          39h
etcd-k8s-master-01                      1/1     Running   0          39h
kube-apiserver-k8s-master-01            1/1     Running   0          39h
kube-controller-manager-k8s-master-01   1/1     Running   0          39h
kube-proxy-s6hc4                        1/1     Running   0          38h
kube-proxy-tzznm                        1/1     Running   0          39h
kube-scheduler-k8s-master-01            1/1     Running   0          39h
```

As you can see , there are many Pods running in `kube-system` namespace
All these Pods were running with one or mode containers
If you see the `calico-node-n99tb` pod , the `READY` says 2/2 , which means two containers were running fine in this Pod

#### List all resources in a namespace
```shell
k8s@k8s-master-01:~$ kubectl get all -n kube-system
NAME                                        READY   STATUS    RESTARTS   AGE
pod/calico-node-kr5xg                       2/2     Running   0          13m
pod/calico-node-lcpbw                       2/2     Running   0          13m
pod/coredns-86c58d9df4-h8pjr                1/1     Running   6          26m
pod/coredns-86c58d9df4-xj24c                1/1     Running   6          26m
pod/etcd-k8s-master-01                      1/1     Running   0          26m
pod/kube-apiserver-k8s-master-01            1/1     Running   0          26m
pod/kube-controller-manager-k8s-master-01   1/1     Running   0          26m
pod/kube-proxy-fl7rj                        1/1     Running   0          26m
pod/kube-proxy-q6w9l                        1/1     Running   0          26m
pod/kube-scheduler-k8s-master-01            1/1     Running   0          26m

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
service/calico-typha   ClusterIP   172.16.244.140   <none>        5473/TCP        13m
service/kube-dns       ClusterIP   172.16.0.10      <none>        53/UDP,53/TCP   27m

NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
daemonset.apps/calico-node   2         2         2       2            2           beta.kubernetes.io/os=linux   13m
daemonset.apps/kube-proxy    2         2         2       2            2           <none>                        27m

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/calico-typha   0/0     0            0           13m
deployment.apps/coredns        2/2     2            2           27m

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/calico-typha-5fc4874c76   0         0         0       13m
replicaset.apps/coredns-86c58d9df4        2         2         2       26m
k8s@k8s-master-01:~$
```
