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

This is not convenient and we need a better mechanism to manage these configuration related operations.

To achieve a persistent configuration , regardless of the Pod state , k8s introduced ConfigMaps.

We can store environmental variables or a file content or both using ConfigMaps.

### Create ConfigMap from literals

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  VAR1: val1
```

### Create ConfigMap from file

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myconfig
data:
  configFile: |
  {
    VAR2=val2
    VAR3: val3
  }
```
