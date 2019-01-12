+++
menutitle = "Nodes"
date = 2018-12-29T17:15:52Z
weight = 4
chapter = false
pre = "<b>- </b>"
+++

# Nodes

In this session , we will explore the node details

#### List nodes
```shell
$ k8s@k8s-master-01:~$ kubectl get nodes
```
Output
```console
NAME            STATUS   ROLES    AGE   VERSION
k8s-master-01   Ready    master   38h   v1.13.1
k8s-worker-01   Ready    <none>   38h   v1.13.1
```


#### Extended listing
```shell
$ kubectl get nodes -o wide
```
Output
```
NAME            STATUS   ROLES    AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
k8s-master-01   Ready    master   38h   v1.13.1   192.168.56.201   <none>        Ubuntu 16.04.5 LTS   4.4.0-131-generic   docker://18.9.0
k8s-worker-01   Ready    <none>   38h   v1.13.1   192.168.56.202   <none>        Ubuntu 16.04.5 LTS   4.4.0-131-generic   docker://18.9.0
k8s@k8s-master-01:~$
```

#### Details on a node
```shell
$ kubectl describe node k8s-master-01
```
Output
```
Name:               k8s-master-01
Roles:              master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=k8s-master-01
                    node-role.kubernetes.io/master=
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
                    node.alpha.kubernetes.io/ttl: 0
                    projectcalico.org/IPv4Address: 192.168.56.201/24
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 31 Dec 2018 02:10:05 +0530
Taints:             node-role.kubernetes.io/master:NoSchedule
Unschedulable:      false
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Tue, 01 Jan 2019 17:01:28 +0530   Mon, 31 Dec 2018 02:10:02 +0530   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Tue, 01 Jan 2019 17:01:28 +0530   Mon, 31 Dec 2018 02:10:02 +0530   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Tue, 01 Jan 2019 17:01:28 +0530   Mon, 31 Dec 2018 02:10:02 +0530   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Tue, 01 Jan 2019 17:01:28 +0530   Mon, 31 Dec 2018 22:59:35 +0530   KubeletReady                 kubelet is posting ready status. AppArmor enabled
Addresses:
  InternalIP:  192.168.56.201
  Hostname:    k8s-master-01
Capacity:
 cpu:                1
 ephemeral-storage:  49732324Ki
 hugepages-2Mi:      0
 memory:             2048168Ki
 pods:               110
Allocatable:
 cpu:                1
 ephemeral-storage:  45833309723
 hugepages-2Mi:      0
 memory:             1945768Ki
 pods:               110
System Info:
 Machine ID:                 96cedf74a821722b0df5ee775c291ea2
 System UUID:                90E04905-218D-4673-A911-9676A65B07C5
 Boot ID:                    14201246-ab82-421e-94f6-ff0d8ad3ba54
 Kernel Version:             4.4.0-131-generic
 OS Image:                   Ubuntu 16.04.5 LTS
 Operating System:           linux
 Architecture:               amd64
 Container Runtime Version:  docker://18.9.0
 Kubelet Version:            v1.13.1
 Kube-Proxy Version:         v1.13.1
PodCIDR:                     192.168.0.0/24
Non-terminated Pods:         (6 in total)
  Namespace                  Name                                     CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
  ---------                  ----                                     ------------  ----------  ---------------  -------------  ---
  kube-system                calico-node-nkcrd                        250m (25%)    0 (0%)      0 (0%)           0 (0%)         38h
  kube-system                etcd-k8s-master-01                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         38h
  kube-system                kube-apiserver-k8s-master-01             250m (25%)    0 (0%)      0 (0%)           0 (0%)         38h
  kube-system                kube-controller-manager-k8s-master-01    200m (20%)    0 (0%)      0 (0%)           0 (0%)         38h
  kube-system                kube-proxy-tzznm                         0 (0%)        0 (0%)      0 (0%)           0 (0%)         38h
  kube-system                kube-scheduler-k8s-master-01             100m (10%)    0 (0%)      0 (0%)           0 (0%)         38h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                800m (80%)  0 (0%)
  memory             0 (0%)      0 (0%)
  ephemeral-storage  0 (0%)      0 (0%)
Events:              <none>
```

We will discuss more about each of the fields on upcoming sessions.
For now lets discuss about `Non-terminated Pods` field;

#### Non-terminated Pods field

- Namespace : The namespace which the Pods were running .
  The pods that we create will by default go to `default` namespace.
- Name : Name of the Pod
- CPU Request : How much CPU resource requested by Pod during startup.
- CPU Limits : How much CPU the Pod can use.
- Memory Request : How much memory requested by Pod during startup.
- Memory Limits : How much memory the Pod can use.
