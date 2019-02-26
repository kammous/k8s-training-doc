+++
menutitle = "Pod Security Policy"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Pod Security Policy

A Pod Security Policy is a cluster-level resource that controls security sensitive aspects of the pod specification. The PodSecurityPolicy objects define a set of conditions that a pod must run with in order to be accepted into the system, as well as defaults for the related fields.

Pod security policy control is implemented as an optional (but recommended) admission controller.
If PSP is not enabled , then enable it in API server using admission-controller flag.

When a `PodSecurityPolicy` resource is created, it does nothing. In order to use it, the requesting user or target pod’s `ServiceAccount` must be authorized to use the policy, by allowing the use verb on the policy.

i.e.;

- A `Role` have to be created first with resource `PodSecurityPolicy` in a namespace
- A `RoleBinding` have to be created from the `ServiceAccount` to the `Role` in a namespace
- Then create a object using  `kubectl --as=<serviceaccount> -n <namespace> ..`

An example PSP is below.

```yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: example
spec:
  privileged: false  # Don't allow privileged pods!
  # The rest fills in some required fields.
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
  volumes:
  - '*'
```

A well documented example is in [official documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/#example)
