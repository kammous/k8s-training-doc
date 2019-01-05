+++
menutitle = "Resource Allocation"
date = 2018-12-29T17:15:52Z
weight = 8
chapter = false
pre = "<b>- </b>"
+++

# Resource Allocation - CPU and Memory allocation for containers.

### Limits
We can limit the CPU and Memory usage of a container so that one

Lets create the coffee Pod again with CPU and Memory limits

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
  name: coffee-limits
spec:
  containers:
  - image: ansilh/demo-coffee
    name: coffee
    resources:
      limits:
        CPU: 100m
        Memory: 123Mi
```

Resulting container will be allowed to use 100 millicores and 123 mebibyte (`~128` Megabytes)

#### CPU

One CPU core is equivalent to `1000m` (one thousand millicpu or one thousand millicores)
CPU is always expressed as an absolute quantity, never as a relative quantity; 0.1 is the same amount of `CPU` on a single-core, dual-core, or 48-core machine

#### Memory
You can express memory as a plain integer or as a fixed-point integer using one of these suffixes: `E, P, T, G, M, K`. You can also use the power-of-two equivalents: `Ei, Pi, Ti, Gi, Mi, Ki`. For example, the following represent roughly the same value:

```cosole
128974848, 129e6, 129M, 123Mi
```

#### Mebibyte vs Megabyte

```console
1 Megabyte (MB) = (1000)^2 bytes = 1000000 bytes.
1 Mebibyte (MiB) = (1024)^2 bytes = 1048576 bytes.
```

#### Requests

We can request a specific amount of CPU and Memory when the container starts up.

Suppose if the Java application need at least `128MB` of memory during startup , we can use resource request in Pod spec.

This will help the scheduler to select a node with enough memory.

Request also can be made of `CPU` as well.

Lets modify the `Pod` spec and add `request`

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
  name: coffee-limits
spec:
  containers:
  - image: ansilh/demo-coffee
    name: coffee
    resources:
      requests:
        CPU: 100m
        Memory: 123Mi
      limits:
        CPU: 200m
        Memory: 244Mi
```

#### Extra
Once you complete the training , you can visit below URLs to understand storage and network limits.

[Storage Limit](https://kubernetes.io/docs/tasks/administer-cluster/limit-storage-consumption/)

[Network bandwidth usage](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/#support-traffic-shaping)
