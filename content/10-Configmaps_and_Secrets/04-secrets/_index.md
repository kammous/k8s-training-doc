+++
menutitle = "Create Secret"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Secrets

A Secret is an object that contains a small amount of sensitive data

To use a secret, a pod needs to reference the secret. A secret can be used with a pod in two ways: as files in a volume mounted on one or more of its containers, or used by kubelet when pulling images for the pod

Secrets will be stored as base64 encoded values and it will be used mostly during creation of an object


### Creating Secrets

##### From variables

```shell
$ kubectl create secret generic my-secret --from-literal=password=mypassword --dry-run -o yaml
```
##### From files

```shell
$ kubectl create secret generic my-secret --from-file=user=user.txt --from-file=password.txt --dry-run -o yaml
```

```shell
$ echo root >user.txt
$ echo password >password.txt
```

```shell
$ kubectl create secret generic my-secret --from-file=user=user.txt --from-file=password=password.txt --dry-run -o yaml
```
