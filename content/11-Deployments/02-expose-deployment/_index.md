+++
menutitle = "Expose Nginx Deployment"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Expose Nginx Deployment

We know how to expose a Pod using a service.

The endpoints will be created based on the label of the Pod.

Here how we can create a service which can be used to access Nginx from outside

First we will check the label of the Pod

```shell
$ kubectl get pod nginx-7cdbd8cdc9-vfbn8 --show-labels
```

Output
```console
NAME                     READY   STATUS    RESTARTS   AGE     LABELS
nginx-7cdbd8cdc9-vfbn8   1/1     Running   0          7m19s   pod-template-hash=7cdbd8cdc9,run=nginx
```

As you can see , one of the label is `run=nginx`

Next write a Service spec and use selector as `run: nginx`

```shell
$ vi nginx-svc.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    run: nginx-svc
  name: nginx-svc
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: nginx
  type: LoadBalancer
```

This service will look for Pods with label "run=nginx"

```shell
$ kubectl apply -f nginx-svc.yaml
```

Verify the service details
```shell
$ kubectl get svc
```

Output
```console
NAME         TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)        AGE
kubernetes   ClusterIP      172.168.0.1      <none>           443/TCP        103m
nginx-svc    LoadBalancer   172.168.47.182   192.168.31.201   80:32369/TCP   3s
```

Now we will be able to see the default nginx page with IP `192.168.31.201`
