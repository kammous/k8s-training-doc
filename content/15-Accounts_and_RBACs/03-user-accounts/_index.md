+++
menutitle = "RBAC"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# RBAC in Action

### Role
In the RBAC API, a role contains rules that represent a set of permissions. Permissions are purely additive (there are no “deny” rules). A role can be defined within a namespace with a Role, or cluster-wide with a ClusterRole

### ClusterRole

A ClusterRole can be used to grant the same permissions as a Role, but because they are cluster-scoped, they can also be used to grant access to:

- cluster-scoped resources (like nodes)
- non-resource endpoints (like “/healthz”)
- namespaced resources (like pods) across all namespaces (needed to run kubectl get pods --all-namespaces, for example)

### Role Binding

A role binding grants the permissions defined in a role to a user or set of users. It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted. Permissions can be granted within a namespace with a RoleBinding


### Cluster Role Binding

A ClusterRoleBinding may be used to grant permission at the cluster level and in all namespaces


A RoleBinding may also reference a ClusterRole to grant the permissions to namespaced resources defined in the ClusterRole within the RoleBinding’s namespace. This allows administrators to define a set of common roles for the entire cluster, then reuse them within multiple namespaces.

We can read more about RBAC , Role , RoleBindings , ClusterRoles and ClusterRole Bindings [here](https://kubernetes.io/docs/reference/access-authn-authz/rbac)


#### Scenario: Provide *read-only* access to *Pods* running in namespace *monitoring*

```
User Name: podview
Namespace: monitoring
```

- Lets create a namespace first

```shell
$ kubectl create ns monitoring
```

```shell
$ kubectl get ns
```
>Output

```
NAME          STATUS   AGE
default       Active   19h
kube-public   Active   19h
kube-system   Active   19h
monitoring    Active   9s
```

- Lets create a CSR JSON and get it signed by the CA

```json
cat <<EOF >podview-csr.json
{
  "CN": "podview",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF
```

- Create CSR Certificate and Sign it using cfssl.
 We moved the ca.pem and ca-key.pem from the home directory while configuring control plane . Lets copy it back to home.

```shell
$ cp -p /var/lib/kubernetes/ca.pem /var/lib/kubernetes/ca-key.pem ~/
```

Generate Certificates

```shell
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  podview-csr.json | cfssljson -bare podview
```
>Output

```
$ ls -lrt podview*
-rw-rw-r-- 1 k8s k8s  235 Feb  3 15:42 podview-csr.json
-rw-rw-r-- 1 k8s k8s 1428 Feb  3 15:48 podview.pem
-rw------- 1 k8s k8s 1675 Feb  3 15:48 podview-key.pem
-rw-r--r-- 1 k8s k8s 1037 Feb  3 15:48 podview.csr
```

Now we can use this certificate to configure `kubectl`.
`kubectl` will read .kube/config .
So you can either modify it manually or use the `kubectl` command to modify it

Lets do a `cat` on existing config.(snipped certificate data)

```yaml
$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: SWUZNY2UxeDZkOWtDMWlKQ1puc0VRL3lnMXBobXYxdkxvWkJqTGlBWkRvCjVJYVd
    server: https://127.0.0.1:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: admin
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: iUUsyU1hLT0lWQXYzR3hNMVRXTUhqVzcvSy9scEtSTFd
    client-key-data: BTCtwb29ic1oxbHJYcXFzTTdaQVN6bUJucldRUTRIU1VFYV
```

- Add new credentials to kubectl configuration

```shell
$ kubectl config set-credentials podview --client-certificate=podview.pem  --client-key=podview-key.pem
```

- Lets see what modifications happened with above command.

```yaml
$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: SWUZNY2UxeDZkOWtDMWlKQ1puc0VRL3lnMXBobXYxdkxvWkJqTGlBWkRvCjVJYVd
    server: https://127.0.0.1:6443
  name: kubernetes-the-hard-way
contexts:
- context:
    cluster: kubernetes-the-hard-way
    user: admin
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: iUUsyU1hLT0lWQXYzR3hNMVRXTUhqVzcvSy9scEtSTFd
    client-key-data: BTCtwb29ic1oxbHJYcXFzTTdaQVN6bUJucldRUTRIU1VFYV
- name: podview
  user:
    client-certificate: /home/k8s/podview.pem
    client-key: /home/k8s/podview-key.pem    
```

As we all know , kubectl by deafult will act on default namespace.
But here we can change that to `monitoring` namespace.

```shell
$ kubectl config set-context podview-context --cluster=kubernetes-the-hard-way --namespace=monitoring --user=podview
```
- Lets see if we can see the Pods

```shell
$ kubectl get pods --context=podview-context
```
>Output

```ruby
Error from server (Forbidden): pods is forbidden: User "podview" cannot list resource "pods" in API group "" in the namespace "monitoring"
```

- Lets create a Role to view Pods

```shell
$ vi podview-role.yaml
```

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: monitoring
  name: podview-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

```shell
$ kubectl create -f podview-role.yaml
```
>Output

```
role.rbac.authorization.k8s.io/podview-role created
```

```shell
$ vi podview-role-binding.yaml
```

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: podview-role-binding
  namespace: monitoring
subjects:
- kind: User
  name: podview
  apiGroup: ""
roleRef:
  kind: Role
  name: podview-role
  apiGroup: ""
```

```shell
$ kubectl create -f podview-role-binding.yaml
rolebinding.rbac.authorization.k8s.io/podview-role-binding created
```

- Verify Role Binding in Action

```shell
$ kubectl get pods --context=podview-context
```

>Output

```
No resources found.
```
