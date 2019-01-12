+++
menutitle = "Self Healing - Liveness"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# Self Healing - Liveness

#### Liveness Probe

Lets assume the application failed after readiness probe execution completes
Again we are back to service unavailability

To avoid this , we need a liveness check which will do a periodic health check after Pod start running or readiness probe completes.

Lets rewrite the Pod specification of Coffee App and add a liveness Probe.
```shell
$ vi pod-liveiness.yaml
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
    readinessProbe:
     initialDelaySeconds: 10
     httpGet:
      port: 9090
    livenessProbe:
     periodSeconds: 5
     httpGet:
      port: 9090
```

#### Create `Pod`
```shell
$ kubectl create -f pod-liveness.yaml
```
