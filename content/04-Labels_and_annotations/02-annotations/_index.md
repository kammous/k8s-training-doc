+++
menutitle = "Annotations"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Why we need annotations ?

We can use either labels or annotations to attach metadata to Kubernetes objects. Labels can be used to select objects and to find collections of objects that satisfy certain conditions. In contrast, annotations are not used to identify and select objects. The metadata in an annotation can be small or large, structured or unstructured, and can include characters not permitted by labels.

Its just a place to store more metadata which is not used for any selection , grouping or operations.

#### Annotate Pod

Lets say , if you want to add a download URL to pod.
```shell
$ kubectl annotate pod coffee-app url=https://hub.docker.com/r/ansilh/demo-webapp
pod/coffee-app annotated
```

#### View annotations

```yaml
k8s@k8s-master-01:~$ kubectl describe pod coffee-app
Name:               coffee-app
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               k8s-worker-01/192.168.56.202
Start Time:         Fri, 04 Jan 2019 00:47:10 +0530
Labels:             app=frontend
                    run=coffee-app
Annotations:        cni.projectcalico.org/podIP: 10.10.1.11/32
                    url: https://hub.docker.com/r/ansilh/demo-webapp
Status:             Running
IP:                 10.10.1.11
...
```

`Annotations` filed containe two entries

`cni.projectcalico.org/podIP: 10.10.1.11/32`

`url: https://hub.docker.com/r/ansilh/demo-webapp`

#### Remove annotation

Use same annotate command and mention only key with a dash (-) at the end of the key .
Below command will remove the annotation `url: https://hub.docker.com/r/ansilh/demo-webapp` from Pod.

```shell
k8s@k8s-master-01:~$ kubectl annotate pod coffee-app url-
pod/coffee-app annotated
k8s@k8s-master-01:~$
```

`Annotation` after removal.

```yaml
k8s@k8s-master-01:~$ kubectl describe pod coffee-app
Name:               coffee-app
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               k8s-worker-01/192.168.56.202
Start Time:         Fri, 04 Jan 2019 00:47:10 +0530
Labels:             app=frontend
                    run=coffee-app
Annotations:        cni.projectcalico.org/podIP: 10.10.1.11/32
Status:             Running
IP:                 10.10.1.11
```
