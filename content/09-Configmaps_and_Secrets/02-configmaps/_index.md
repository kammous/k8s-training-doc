+++
menutitle = "ConfigMaps"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# ConfigMaps

In this session , we will explore the use of `ConfigMaps`.

If you want to customize the configuration of an application inside a Pod , you have to change the configuration files inside the container and then we have to wait for the application to re-read the updated configuration file.

When Pod lifecycle ends , the changes we made will be lost and we have to redo the same changes when the Pod comes-up.

This is not convenient and we need a better way to manage these configuration related operations.

To achieve a persistent configuration regardless of the Pod state , k8s introduced ConfigMaps.

We can store environmental variables or a file content or both using ConfigMaps in k8s.

Use the `kubectl create configmap` command to create configmaps from directories, files, or literal values:

where <map-name> is the name you want to assign to the ConfigMap and <data-source> is the directory, file, or literal value to draw the data from.

The data source corresponds to a key-value pair in the ConfigMap, where

key = the file name or the key you provided on the command line, and
value = the file contents or the literal value you provided on the command line.
You can use kubectl describe or kubectl get to retrieve information about a ConfigMap


#### Create ConfigMap from literals - Declarative

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  VAR1: val1
```

#### Create ConfigMap from literals - Imperative

```shell
$ kubectl create configmap myconfig --from-literal=VAR1=val1
```

#### Create ConfigMap from file - Declarative

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  configFile: |
    This content is coming from a file
    Also this file have multiple lines
```
#### Create ConfigMap from file - Imperative

```shell
$ cat <<EOF >configFile
This content is coming from a file
EOF
```

```shell
$ cat configFile
```

```shell
$ kubectl create configmap myconfig --from-file=configFile
```
