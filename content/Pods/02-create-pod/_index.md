+++
menutitle = "Create a Pod - Declarative"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Create a Coffee App Pod - Declarative Way

### Lets Check the running Pods
```bash
k8s@k8s-master-01:~$ kubectl get pods
No resources found.
k8s@k8s-master-01:~$
```
Nothing <i class="fa fa-frown"></i>

### Lets create one using a `YAML` file
```bash
vi pod.yaml
```

```yml
apiVersion: v1
kind: Pod
metadata:
  name: coffee-app
spec:
  containers:
  - image: ansilh/demo-coffee
    name: coffee
```

### Apply YAML using `kubectl` command
```bash
k8s@k8s-master-01:~$ kubectl apply -f pod.yaml
pod/coffee-app created
k8s@k8s-master-01:~$
```

### View status of Pod
Pod status is `ContainerCreating`
```ruby
k8s@k8s-master-01:~$ kubectl get pods
NAME         READY   STATUS              RESTARTS   AGE
coffee-app   0/1     ContainerCreating   0          4s
k8s@k8s-master-01:~$
```

Execute `kubectl get pods` after some time
Now `Pod` status will change to `Running`
```bash
k8s@k8s-master-01:~$ kubectl get pods
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   1/1     Running   0          27s
k8s@k8s-master-01:~$
```

Now we can see our first Pod <i class="fa fa-smile-beam"></i>

### Get the IP address of `Pod`
```bash
k8s@k8s-master-01:~$ kubectl get pods -o wide
NAME         READY   STATUS    RESTARTS   AGE    IP            NODE            NOMINATED NODE   READINESS GATES
coffee-app   1/1     Running   0          2m8s   192.168.1.7   k8s-worker-01   <none>           <none>
k8s@k8s-master-01:~$
```

### Verify Coffee app using curl
```bash
$ curl -s 192.168.1.7:9090  |grep 'Serving Coffee'
<html><head></head><title></title><body><div> <h2>Serving Coffee from</h2><h3>Pod:coffee-app</h3><h3>IP:192.168.1.7</h3><h3>Node:10.96.0.1</h3><img src="data:image/png;base64,
```

### Delete pod
```bash
k8s@k8s-master-01:~$ kubectl delete pod coffee-app
pod "coffee-app" deleted
k8s@k8s-master-01:~$ kubectl get pods
No resources found.
k8s@k8s-master-01:~$
```
