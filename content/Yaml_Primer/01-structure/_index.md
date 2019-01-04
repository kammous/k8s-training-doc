+++
menutitle = "K8S YAML structure"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# K8S YAML structure

#### What is YAML

Yet Another Markup Language

Kubernetes YAML have below structure
```yaml
apiVersion:
kind:
metadata:
spec:
```

#### apiVersion:

Kubernetes have different versions of API for each objects.
We discuss about API in detail in upcoming sessions.
For now , lets keep it simple as possible.

Pod is one of the `kind` of object which is part of core v1 API
So for a Pod, we usually see `apiVersion: v1`

#### kind:

As explained above we specify the `kind` of API object with `kind:` field.

#### metadata:

We have seen the use of metadata earlier.

As the name implies , we usually store name of object and labels in metadata field.

#### spec:

Object specification will go hear.
The specification will depend on the `kind` and `apiVersion` we use

#### Exploring `Pod` spec

Lets write a Pod specification YAML

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

In above specification , you can see that we have specified `name` and `labels` in matadata field.

The `spec` starts with `cotainer` field and we have added a container specification under it.

You might be wondering , how can we memories all these options.
In reality , you don't have to.

We will discuss about it in next session.
