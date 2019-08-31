+++
menutitle = "Taints and Tolerations"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Taints and Tolerations

You add a taint to a node using kubectl taint. For example,

```shell
$ kubectl taint nodes k8s-worker-02 key=value:NoSchedule
```

places a taint on node node1. The taint has key key, value value, and taint effect `NoSchedule`. This means that no pod will be able to schedule onto node1 unless it has a matching toleration.

To remove the taint added by the command above, you can run:
```shell
kubectl taint nodes k8s-worker-02 key:NoSchedule-
```

You specify a toleration for a pod in the `PodSpec`. Both of the following tolerations “match” the taint created by the `kubectl` taint line above, and thus a pod with either toleration would be able to schedule onto node1:

```yaml
tolerations:
- key: "key"
  operator: "Equal"
  value: "value"
  effect: "NoSchedule"
```

```
tolerations:
- key: "key"
  operator: "Exists"
  effect: "NoSchedule"
```

A toleration “matches” a taint if the keys are the same and the effects are the same, and:

- the operator is Exists (in which case no value should be specified), or
- the operator is Equal and the values are equal
Operator defaults to Equal if not specified.


The above example used effect of `NoSchedule`. Alternatively, you can use effect of `PreferNoSchedule`. This is a “preference” or “soft” version of `NoSchedule` – the system will try to avoid placing a pod that does not tolerate the taint on the node, but it is not required. The third kind of effect is NoExecute

Normally, if a taint with effect `NoExecute` is added to a node, then any pods that do not tolerate the taint will be evicted immediately, and any pods that do tolerate the taint will never be evicted. However, a toleration with `NoExecute` effect can specify an optional `tolerationSeconds` field that dictates how long the pod will stay bound to the node after the taint is added. For example,

```yaml
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoExecute"
  tolerationSeconds: 3600
```
