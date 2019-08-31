+++
menutitle = "Pod - manual scheduling"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Pod Scheduling

### Node Selector

Suppose you have a Pod which needs to be running on a Pod which is having SSD in it.

First we need to add a label to the node which is having SSD

```shell
$ kubectl label node k8s-worker-01 disktype=ssd
```

Now we can write a Pod spec with `nodeSelector`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    disktype: ssd
```

Scheduler will look at the node selector and select apropriate node to run the pod

### nodeName

- Kube-scheduler will find a suitable pod by evaluating the constraints.
- Scheduler will modify the value of .spec.nodeName of Pod object .
- kubelet will observe the change via API server and will start the pod based on the specification.

This means , we can manually specify the `nodeName` in `Pod` spec and schedule it.

You can read more about `nodeName` in below URL
https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodename
