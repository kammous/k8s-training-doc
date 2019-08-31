+++
menutitle = "Expose Pod"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Expose service running on Pod.

#### Service
A Coffee Pod running in cluster and its listening on port 9090 on Pod's IP.
How can we expose that service to external world so that users can access it ?

![Pod](pod-service.png?classess=shadow)

We need to `expose` the service.

As we know , the Pod IP is not routable outside of the cluster.
So we need a mechanism to reach the host's port and then that traffic should be diverted to Pod's port.

Lets create a Pod Yaml first.

```shell
$ vi coffe.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: coffee
spec:
  containers:
  - image: ansilh/demo-coffee
    name: coffee
```
Create Yaml
```
$ kubectl create -f coffe.yaml
```

Expose the Pod with below command
```
$ kubectl expose pod coffee --port=80 --target-port=9090  --type=NodePort
```

This will create a `Service` object in kubernetes , which will map the Node's port 30836 to `Service` IP/Port 192.168.10.86:80

We can see the derails using `kubectl get service` command  
```
$ kubectl get service
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
coffee       NodePort    192.168.10.86    <none>        80:30391/TCP   6s
kubernetes   ClusterIP   192.168.10.1     <none>        443/TCP        26h
```

We can also see that the port is listening and kube-proxy is the one listening on that port.

```
$ sudo netstat -tnlup |grep 30836
tcp6       0      0 :::30391                :::*                    LISTEN      2785/kube-proxy
```

Now you can open browser and access the `Coffee` app using URL `http://192.168.56.201:30391`

## Ports in Service Objects

#### nodePort
This setting makes the service visible outside the Kubernetes cluster by the node’s IP address and the port number declared in this property. The service also has to be of type NodePort (if this field isn’t specified, Kubernetes will allocate a node port automatically).

#### port
Expose the service on the specified port internally within the cluster. That is, the service becomes visible on this port, and will send requests made to this port to the pods selected by the service.

#### targetPort
This is the port on the pod that the request gets sent to. Your application needs to be listening for network requests on this port for the service to work.
