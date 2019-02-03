
When you (a human) access the cluster (for example, using kubectl), you are authenticated by the apiserver as a particular User Account (currently this is usually admin, unless your cluster administrator has customized your cluster).
Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, default).

When you create a pod, if you do not specify a service account, it is automatically assigned the default service account in the same namespace.

```shell
$ kubectl get pods nginx --output=jsonpath={.spec.serviceAccount} && echo
```

You can access the API from inside a pod using automatically mounted service account credentials.
