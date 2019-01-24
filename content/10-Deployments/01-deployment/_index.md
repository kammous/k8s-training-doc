+++
menutitle = "Nginx Deployment"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Create an Nginx Deployment

```shell
$ kubectl run nginx --image=nginx
```

Output

```console
deployment.apps/nginx created
```

Verify the Pods running

```shell
$ kubectl get pods
```
Output

```console
NAME                     READY   STATUS    RESTARTS   AGE
nginx-7cdbd8cdc9-9xsms   1/1     Running   0          27s
```

Here we can see that the Pod name is not like the usual one.

Lets delete the Pod and see what will happen.

```shell
$ kubectl delete pod nginx-7cdbd8cdc9-9xsms
```

Output

```console
pod "nginx-7cdbd8cdc9-9xsms" deleted
```

Verify Pod status
```shell
$ kubectl get pods
```

Output

```console
NAME                     READY   STATUS    RESTARTS   AGE
nginx-7cdbd8cdc9-vfbn8   1/1     Running   0          81s
```
A new Pod has been created again !!!
