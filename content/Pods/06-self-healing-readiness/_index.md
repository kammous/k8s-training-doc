+++
menutitle = "Self Healing - Readiness"
date = 2018-12-29T17:15:52Z
weight = 6
chapter = false
pre = "<b>- </b>"
+++

# Self Healing - Readiness

### Readiness Probe

We have seen that our coffee application was listening on port 9090.
Lets assume that the application is not coming up but Pod status showing running.
Everyone will think that application is up.
You entire application stack might get affected because of this.

So here comes the question , "How can I make sure my application is started, not just the Pod ?"

Here we can use Pod spec, `Readiness probe`.

Official detention of readinessProbe is , "Periodic probe of container service readiness".

Lets rewrite the Pod specification of Coffee App and add a readiness Probe.
```shell
$ vi pod-readiness.yaml
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
```

#### Apply Yaml
```shell
$ kubectl apply -f pod-readiness.yaml
pod/coffee-app created
```

#### Verify Pod status

Try to identify the difference.
```shell
$ kubectl get pods
NAME         READY   STATUS              RESTARTS   AGE
coffee-app   0/1     ContainerCreating   0          3s
$ kubectl get pods
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   0/1     Running   0          25s
$ kubectl get pods
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   1/1     Running   0          32s
```

#### Delete the Pod
Yes ,we can delete the objects using the same yaml which we used to create/apply it
```shell
$ kubectl delete -f pod-readiness.yaml
pod "coffee-app" deleted
$
```

#### Probe Tuning.
```
failureThreshold     <integer>
  Minimum consecutive failures for the probe to be considered failed after
  having succeeded. Defaults to 3. Minimum value is 1.

initialDelaySeconds  <integer>
  Number of seconds after the container has started before liveness probes
  are initiated. More info:
  https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

periodSeconds        <integer>
  How often (in seconds) to perform the probe. Default to 10 seconds. Minimum
  value is 1.

timeoutSeconds       <integer>
  Number of seconds after which the probe times out. Defaults to 1 second.
  Minimum value is 1. More info:
  https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
```
