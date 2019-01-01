+++
menutitle = "Create a Pod - Imperative"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Create Pod - Imperative Way


### Execute `kubectl` command to create a Pod.
```shell
k8s@k8s-master-01:~$ kubectl run coffee --image=ansilh/demo-coffee --restart=Never
pod/coffee created
k8s@k8s-master-01:~$
```

### Verify `Pod` status
```shell
k8s@k8s-master-01:~$ kubectl get pods -o wide
NAME     READY   STATUS    RESTARTS   AGE   IP            NODE            NOMINATED NODE   READINESS GATES
coffee   1/1     Running   0          21s   192.168.1.8   k8s-worker-01   <none>           <none>
k8s@k8s-master-01:~$
```

### Verify `Coffee` App status
```shell
$ curl -s 192.168.1.8:9090  |grep 'Serving Coffee'
<html><head></head><title></title><body><div> <h2>Serving Coffee from</h2><h3>Pod:coffee</h3><h3>IP:192.168.1.8</h3><h3>Node:10.96.0.1</h3><img src="data:image/png;base64,
k8s@k8s-master-01:~$
```

### Delete pod
```shell
k8s@k8s-master-01:~$ kubectl delete pod coffee-app
pod "coffee-app" deleted
k8s@k8s-master-01:~$ kubectl get pods
No resources found.
k8s@k8s-master-01:~$
```
