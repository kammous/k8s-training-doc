+++
menutitle = "Rollout Demo"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

### Creating a Deployment

```shell
$ vi nginx-deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

```shell
$ kubectl create -f nginx-deployment.yaml
```
>Output

```
deployment.apps/nginx-deployment created
```

```shell
$ kubectl get all
```
>Output

```yaml
NAME                                    READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-76bf4969df-c7jrz   1/1     Running   0          38s --+
pod/nginx-deployment-76bf4969df-gl5cv   1/1     Running   0          38s   |-----> These Pods are spawned by ReplicaSet nginx-deployment-76bf4969df
pod/nginx-deployment-76bf4969df-kgmx9   1/1     Running   0          38s --+

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/kubernetes   ClusterIP   172.168.0.1      <none>        443/TCP        3d23h

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           38s ---------> Deployment

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-76bf4969df   3         3         3       38s ---> ReplicaSet
```
As we already know , Deployment controller uses labels to select the Pods
In Yaml spec , you can see below selector fields.

```yaml
selector:
  matchLabels:
    app: nginx
```

Lets examine the Pods.
We can see that there are two labels.
The pod-template-hash label is added by the Deployment controller to every ReplicaSet that a Deployment creates or adopts.

```
$ kubectl get pods --show-labels
```

>Output

```yaml
NAME                                READY   STATUS    RESTARTS   AGE     LABELS
nginx-deployment-76bf4969df-hm5hf   1/1     Running   0          3m44s   app=nginx,pod-template-hash=76bf4969df
nginx-deployment-76bf4969df-tqn2k   1/1     Running   0          3m44s   app=nginx,pod-template-hash=76bf4969df
nginx-deployment-76bf4969df-wjmqp   1/1     Running   0          3m44s   app=nginx,pod-template-hash=76bf4969df
```

You may see the parameters of a replicaset using below command.

```shell
$ kubectl get replicasets nginx-deployment-76bf4969df -o yaml --export
```

We can update the nginx image to a new version using `set image`.

Here we are executing both `set image` and `rollout status` together so that we can monitor the status.

```shell
$ kubectl set image deployment nginx-deployment nginx=nginx:1.9.1 ; kubectl rollout status deployment nginx-deployment
```

>Output

```yaml
deployment.extensions/nginx-deployment image updated
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "nginx-deployment" rollout to finish: 1 old replicas are pending termination...
deployment "nginx-deployment" successfully rolled out
```

To view the history of rollout

```
$ kubectl rollout history deployment nginx-deployment
```

>Output

```
deployment.extensions/nginx-deployment
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```

To see the changes we made on each version, we can use below commands

```shell
$ kubectl rollout history deployment nginx-deployment --revision=1
```

First revision have image `nginx:1.7.9`

```properties
deployment.extensions/nginx-deployment with revision #1
Pod Template:
  Labels:       app=nginx
        pod-template-hash=76bf4969df
  Containers:
   nginx:
    Image:      nginx:1.7.9
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

First revision have image `nginx:1.9.1`

```shell
$ kubectl rollout history deployment nginx-deployment --revision=2
```

```properties
deployment.extensions/nginx-deployment with revision #2
Pod Template:
  Labels:       app=nginx
        pod-template-hash=779fcd779f
  Containers:
   nginx:
    Image:      nginx:1.9.1
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

Now lets rollback the update.

```shell
$ kubectl rollout undo deployment nginx-deployment ;kubectl rollout status deployment nginx-deployment
```

>Output

```yaml
deployment.extensions/nginx-deployment rolled back
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "nginx-deployment" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "nginx-deployment" rollout to finish: 1 old replicas are pending termination...
deployment "nginx-deployment" successfully rolled out
```

Now we have revision 2 and 3.

When we rollback version 1 become 3 .
In this way the latest active one and the previous revision will be the highest and second highest revisions respectively.
This logic will allow quick rollbacks.


```
$ kubectl rollout history deployment nginx-deployment
```

```shell
deployment.extensions/nginx-deployment
REVISION  CHANGE-CAUSE
2         <none>
3         <none>
```

Check each revision changes

```shell
$ kubectl rollout history deployment nginx-deployment --revision=2
```

```properties
deployment.extensions/nginx-deployment with revision #2
Pod Template:
  Labels:       app=nginx
        pod-template-hash=779fcd779f
  Containers:
   nginx:
    Image:      nginx:1.9.1
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

```shell
$ kubectl rollout history deployment nginx-deployment --revision=3
```

```properties
deployment.extensions/nginx-deployment with revision #3
Pod Template:
  Labels:       app=nginx
        pod-template-hash=76bf4969df
  Containers:
   nginx:
    Image:      nginx:1.7.9
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

Lets check the status of replicaset

```shell
$ kubectl get rs
```

```
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-76bf4969df   3         3         3       145m
nginx-deployment-779fcd779f   0         0         0       69m
```

Here we can see two replicaset

```shell
$ kubectl describe rs nginx-deployment-76bf4969df
```

```yaml
Name:           nginx-deployment-76bf4969df
Namespace:      default
Selector:       app=nginx,pod-template-hash=76bf4969df
Labels:         app=nginx
                pod-template-hash=76bf4969df
Annotations:    deployment.kubernetes.io/desired-replicas: 3
                deployment.kubernetes.io/max-replicas: 4
                deployment.kubernetes.io/revision: 3
                deployment.kubernetes.io/revision-history: 1
Controlled By:  Deployment/nginx-deployment
Replicas:       3 current / 3 desired  <<<<<<<<<<<<<<-------------------------
Pods Status:    3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=nginx
           pod-template-hash=76bf4969df
  Containers:
   nginx:
    Image:        nginx:1.7.9 <<<<<<<<<<<<<<-------------------------
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:           <none>
```

```shell
$ kubectl describe rs nginx-deployment-779fcd779f
```

```yaml
Name:           nginx-deployment-779fcd779f
Namespace:      default
Selector:       app=nginx,pod-template-hash=779fcd779f
Labels:         app=nginx
                pod-template-hash=779fcd779f
Annotations:    deployment.kubernetes.io/desired-replicas: 3
                deployment.kubernetes.io/max-replicas: 4
                deployment.kubernetes.io/revision: 2
Controlled By:  Deployment/nginx-deployment
Replicas:       0 current / 0 desired <<<<<<<<<<<<<<-------------------------
Pods Status:    0 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=nginx
           pod-template-hash=779fcd779f
  Containers:
   nginx:
    Image:        nginx:1.9.1 <<<<<<<<<<<<<<-------------------------
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:           <none>
```

We can pause and resume a rollout using below commands

```shell
$ kubectl rollout pause deployment nginx-deployment
```

```shell
$ kubectl rollout resume deployment nginx-deployment
```

We can use `revisionHistoryLimit` field in a Deployment to specify how many old ReplicaSets for this Deployment you want to retain. The rest will be garbage-collected in the background. By default, it is 10

We can read more about `strategy` [here](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)
