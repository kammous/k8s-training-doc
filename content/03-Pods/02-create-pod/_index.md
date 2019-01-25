+++
menutitle = "Create a Pod - Declarative"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Pod - Declarative Way

After completing this session , you will be able to create Pod declaratively and will be able to login to check services running on other pods.

So lets get started.

#### Lets Check the running Pods

```shell
k8s@k8s-master-01:~$ kubectl get pods
No resources found.
k8s@k8s-master-01:~$
```
Nothing <i class="fa fa-frown"></i>

#### Lets create one using a `YAML` file

```shell
$ vi pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: coffee-app
spec:
  containers:
  - image: ansilh/demo-coffee
    name: coffee
```

#### Apply YAML using `kubectl` command

```shell
$ kubectl apply -f pod.yaml
```

#### View status of Pod

Pod status is `ContainerCreating`
```shell
$ kubectl get pods
```
Output
```console
NAME         READY   STATUS              RESTARTS   AGE
coffee-app   0/1     ContainerCreating   0          4s
```

#### Execute `kubectl get pods` after some time
Now `Pod` status will change to `Running`

```shell
$ kubectl get pods
```
Output
```console
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   1/1     Running   0          27s
```

Now we can see our first Pod <i class="fa fa-smile-beam"></i>

#### Get the IP address of `Pod`
```shell
$ kubectl get pods -o wide
```
Output

```console
NAME         READY   STATUS    RESTARTS   AGE    IP            NODE            NOMINATED NODE   READINESS GATES
coffee-app   1/1     Running   0          2m8s   192.168.1.7   k8s-worker-01   <none>           <none>
```

#### Create a new CentOS container
```shell
$ vi centos-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: centos-pod
spec:
  containers:
  - image: tutum/centos
    name: centos
```

#### Apply the Yaml spec
```shell
$ kubectl apply -f centos-pod.yaml
```

#### Verify the status of Pod
```shell
$ kubectl get pods
```

```console
NAME         READY   STATUS              RESTARTS   AGE
centos-pod   0/1     ContainerCreating   0          12s
coffee-app   1/1     Running             0          5m31s
```

#### After some time status will change to Running
```shell
$ kubectl get pods
```

```shell
NAME         READY   STATUS    RESTARTS   AGE
centos-pod   1/1     Running   0          59s
coffee-app   1/1     Running   0          6m18s
```

#### Login to CentOS Pod
```shell
$ kubectl exec -it centos-pod -- /bin/bash
```

#### Verify Coffee app using curl
```shell
$ curl -s 192.168.1.13:9090  |grep 'Serving'
```
```console
<html><head></head><title></title><body><div> <h2>Serving Coffee from</h2><h3>Pod:coffee-app</h3><h3>IP:192.168.1.13</h3><h3>Node:172.16.0.1</h3><img src="data:image/png;base64,
[root@centos-pod /]#
```

#### Delete pod
```shell
$ kubectl delete pod coffee-app centos-pod
```

```console
pod "coffee-app" deleted
pod "centos-pod" deleted
```

#### Make sure not pod is running 
```shell
$ kubectl get pods
```
