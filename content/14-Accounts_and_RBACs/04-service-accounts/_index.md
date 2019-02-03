+++
menutitle = "Service Accounts"
date = 2018-12-29T17:15:52Z
weight = 4
chapter = false
pre = "<b>- </b>"
+++

# Service Accounts and Tokens

When you (a human) access the cluster (for example, using kubectl), you are authenticated by the apiserver as a particular User Account (currently this is usually admin, unless your cluster administrator has customized your cluster).
Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, default).

When you create a pod, it is automatically assigns the default service account in the same namespace.

```shell
$ kubectl get pods nginx --output=jsonpath={.spec.serviceAccount} && echo
```

You can access the API from inside a pod using automatically mounted service account credentials.

Lets start a Pod

```
$ kubectl run debugger --image=ansilh/debug-tools --restart=Never
```

Login to the Pod

```
$ kubectl exec -it debugger -- /bin/sh
```

Kubernetes will inject KUBERNETES_SERVICE_HOST & KUBERNETES_SERVICE_PORT_HTTPS variables to the Pod during object creation.
We can use these variables to formulate the API URL

Also , there is a bearer token which kubernetes mounts to the pod via path /run/secrets/kubernetes.io/serviceaccount/token
We can use this bearer token and pass it as part of HTTP header.

```
APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
```

Use curl command to access the API details

```
curl $APISERVER/api  --header "Authorization: Bearer $TOKEN" --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt
```

>Output

```json
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "10.136.102.232:6443"
    }
  ]
}
