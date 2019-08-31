+++
menutitle = "Exploring Object Specs"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# Exploring Object Specs

So lets discuss about a new command `kubectl explain` so that we don't have to remember all YAML specs of kubernetes objects.

With `kubectl explain` subcommand , you can see the specification of each objects and can use that as a reference to write your `YAML` files.

#### Fist level spec

We will use `kubectl explain Pod` command to see the specifications of a Pod YAML.

```
$ kubectl explain Pod
```

Output
```
ubuntu@k8s-master-01:~$ kubectl explain pod
KIND:     Pod
VERSION:  v1

DESCRIPTION:
     Pod is a collection of containers that can run on a host. This resource is
     created by clients and scheduled onto hosts.

FIELDS:
   apiVersion	<string>
     APIVersion defines the versioned schema of this representation of an
     object. Servers should convert recognized schemas to the latest internal
     value, and may reject unrecognized values. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#resources

   kind	<string>
     Kind is a string value representing the REST resource this object
     represents. Servers may infer this from the endpoint the client submits
     requests to. Cannot be updated. In CamelCase. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds

   metadata	<Object>
     Standard object's metadata. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

   spec	<Object>
     Specification of the desired behavior of the pod. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status

   status	<Object>
     Most recently observed status of the pod. This data may not be up to date.
     Populated by the system. Read-only. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status

ubuntu@k8s-master-01:~$
```

As we discussed earlier , the specification is very familiar.

Filed `status` is readonly and its system populated , so we don't have to write anything for `status`.

#### Exploring inner fields

If we want to see the fields available in `spec` , then execute below command.
```shell
$ kubectl explain pod.spec
```
```yaml
KIND:     Pod
VERSION:  v1

RESOURCE: spec <Object>

DESCRIPTION:
     Specification of the desired behavior of the pod. More info:
     https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status

     PodSpec is a description of a pod.

FIELDS:
...
containers	<[]Object> -required-
  List of containers belonging to the pod. Containers cannot currently be
  added or removed. There must be at least one container in a Pod. Cannot be
  updated.
...

```

How easy is that.

As you can see in spec the `containers` filed is `-required-` which indicates that this filed is mandatory.

`<[]Object>` indicates that its an array of objects , which means , you can put more than one element under `containers`

That make sense , because the `Pod` may contain more than one container.

In YAML we can use `-` infront of a filed to mark it as an array element.

Lets take a look at the YAML that we wrote earlier

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: coffee-app01
 labels:
  app: frontend
  run: coffee-app01
spec:
 containers:
 - name: demo-coffee
   image: ansilh/demo-coffee
```  

There is a `-` under the fist filed of the `containers`.
If we say that in words ; "containers is an array object which contains one array element with filed `name` and `image`"

If you want to add one more container in Pod , we will add one more array element with needed values.

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: coffee-app01
 labels:
  app: frontend
  run: coffee-app01
spec:
 containers:
 - name: demo-coffee
   image: ansilh/demo-coffee
 - name: demo-tea
   image: ansilh/demo-tea
```  

Now the Pod have two containers .

How I know the containers array element need `name` and `image` ?

We will use explain command to get those details.
```shell
$ kubectl explain pod.spec.containers
```
Snipped Output
```
...
name	<string> -required-
  Name of the container specified as a DNS_LABEL. Each container in a pod
  must have a unique name (DNS_LABEL). Cannot be updated.

image	<string>
  Docker image name
...
```

As you can see , `name` and `image` are of type `string` which means , you have to provide a string value to it.
