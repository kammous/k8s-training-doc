+++
menutitle = "Use ConfigMaps in Pods"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++


# Define container environment variables using ConfigMap data

### Define a container environment variable with data from a single ConfigMap
- Define an environment variable as a key-value pair in a ConfigMap:

```shell
$ kubectl create configmap special-config --from-literal=special.how=very
```

- Assign the special.how value defined in the ConfigMap to the SPECIAL_LEVEL_KEY environment variable in the Pod specification.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        # Define the environment variable
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
              name: special-config
              # Specify the key associated with the value
              key: special.how
  restartPolicy: Never
```

### Configure all key-value pairs in a ConfigMap as container environment variables

- Create a ConfigMap containing multiple key-value pairs.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config
  namespace: default
data:
  SPECIAL_LEVEL: very
  SPECIAL_TYPE: charm
```

- Use envFrom to define all of the ConfigMap’s data as container environment variables. The key from the ConfigMap becomes the environment variable name in the Pod.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      envFrom:
      - configMapRef:
          name: special-config
  restartPolicy: Never
```

More about configmap can bre read from below link.
https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
