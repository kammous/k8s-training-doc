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
```

From where we get this Token and how kubernetes know this token is for which user or group ?

**Kubernetes uses *service accounts* and *tokens* to pass authentication and authorization data to objects**

When you create a Pod object , kubernetes will use `default` service account and inject the token corresponding to the default user.

Lets see the service accounts in default namespace.

```
$ kubectl get serviceaccounts
```

>Output

```
NAME      SECRETS   AGE
default   1         24h
```

Who creates this service account ?

The `default` service account will be created by kubernetes during namespace creation.
Which means , when ever you create a namespace , a default service account will also be created.

In RBAC scheme , the service account will have below naming convention

system:serviceaccount:<namespace>:<user>

Lets try to access another API endpoint

```shell
curl $APISERVER/api/v1/pods  --header "Authorization: Bearer $TOKEN" --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt
```

>Output

```json
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" at the cluster scope",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}
```

This indicates that the `default` account have no view access to objects in that namespace

How can give access in this case ?

- Create a new service account
- Create a Role
- Map the Role to the service account using RoleMapping
- Finally , use the newly created service account to access objects


We already discussed about Roles and RoleMappings in previous [session](/14-accounts_and_rbacs/03-user-accounts/)
But we didn't discuss about service accounts or using the service accounts.

Lets demonstrate that then.

- Create a service account called podview

```shell
$ kubectl create serviceaccount podview
```

```
$ kubectl get serviceaccounts podview -o yaml
```

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2019-02-03T16:53:32Z"
  name: podview
  namespace: default
  resourceVersion: "131763"
  selfLink: /api/v1/namespaces/default/serviceaccounts/podview
  uid: 3d601276-27d4-11e9-aa2d-506b8db54343
secrets:
- name: podview-token-4blzv
```

Here we can see a secret named **podview-token-4blzv**

```shell
$ kubectl get secrets podview-token-4blzv -o yaml
```

```yaml
apiVersion: v1
data:
  ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FUR
  namespace: ZGVmYXVsdA==
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXR
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: podview
    kubernetes.io/service-account.uid: 3d601276-27d4-11e9-aa2d-506b8db54343
  creationTimestamp: "2019-02-03T16:53:32Z"
  name: podview-token-4blzv
  namespace: default
  resourceVersion: "131762"
  selfLink: /api/v1/namespaces/default/secrets/podview-token-4blzv
  uid: 3d61d6ce-27d4-11e9-aa2d-506b8db54343
type: kubernetes.io/service-account-token
```
(keys were snipped to fit screen)

The type is kubernetes.io/service-account-token and we can see ca.crt , namespace (base64 encoded) and a token
These fields will be injected to the Pod if we use the service account `podview` to create the Pod.

```shell
$ vi pod-token.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debugger
spec:
  containers:
  - image: ansilh/debug-tools
    name: debugger
  serviceAccountName: podview
```

```shell
$ kubectl create -f pod-token.yaml
```

```shell
$ kubectl exec -it debugger -- /bin/sh
```

```shell
APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)

curl $APISERVER/api/v1/pods  --header "Authorization: Bearer $TOKEN" --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt
```

```json
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "pods is forbidden: User \"system:serviceaccount:default:podview\" cannot list resource \"pods\" in API group \"\" at the cluster scope",
  "reason": "Forbidden",
  "details": {
    "kind": "pods"
  },
  "code": 403
}
```

We got the same message as the one we got while using default account.
Message says that the service account don't have access to Pod object.

So we will create a ClusterRole first , which will allow this user to access all Pods

```shell
$ kubectl create clusterrole podview-role --verb=get,list,watch --resource=pods --dry-run -o yaml
```
>Output

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: podview-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - list
  - watch
```

```shell
$ kubectl create clusterrole podview-role --verb=list,watch --resource=pods
```

>Output

```
clusterrole.rbac.authorization.k8s.io/podview-role created
```

Now we will bind this role to the user podview

```shell
$ kubectl create clusterrolebinding podview-role-binding --clusterrole=podview-role --serviceaccount=default:podview  --dry-run -o yaml
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: podview-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: podview-role
subjects:
- kind: ServiceAccount
  name: podview
  namespace: default
```

```shell
$ kubectl create clusterrolebinding podview-role-binding --clusterrole=podview-role --serviceaccount=default:podview
```

>Output

```
clusterrolebinding.rbac.authorization.k8s.io/podview-role-binding created
```

Lets try to access the API from pod again

```console
k8s@k8s-master-ah-01:~$ kubectl exec -it debugger -- /bin/sh
/ # APISERVER=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS}
/ # TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
/ #
/ # curl $APISERVER/api/v1/pods  --header "Authorization: Bearer $TOKEN" --cacert /run/secrets/kubernetes.io/serviceaccount/ca.crt
```

(If not working , then delete the service account and recreate it. Need to verify this step)

You can also create a single yaml file for ServiceAccount , ClusterRole and ClusterRoleBinding

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: podview
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: podview-role
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: podview-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: podview-role
subjects:
- kind: ServiceAccount
  name: podview
  namespace: default
```
