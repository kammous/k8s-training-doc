+++
menutitle = "Rollback"
date = 2018-12-29T17:15:52Z
weight = 5
chapter = false
pre = "<b>- </b>"
+++

# Rollback

#### List revisions

```shell
$ helm list
```

>Output

```yaml
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
ungaged-possum  2               Fri Mar 15 18:17:52 2019        DEPLOYED        nginx-deployment-1                      default
```

#### Rollback to revision 1

```shell
$ helm rollback ungaged-possum 1
```

>Output

```console
Rollback was a success! Happy Helming!
```

#### List the revision after rollback

```shell
$ helm list
```

>Output

```yaml
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
ungaged-possum  3               Sat Mar 16 10:14:47 2019        DEPLOYED        nginx-deployment-1                      default
```

#### Verify rollback

```shell
$ kubectl get pods
```

>Output

```yaml
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-64f767964b-trx7h   1/1     Running   0          44s
```

```shell
$ kubectl exec nginx-deployment-64f767964b-trx7h -- nginx -v
```

>Output

```yaml
nginx version: nginx/1.9.10
```

#### Examine the changes between active revision and previous one.

```shell
$ sdiff <(helm get ungaged-possum --revision=2) <(helm get ungaged-possum --revision=3)
```

>Output

```yaml
REVISION: 2                                                   | REVISION: 3
RELEASED: Fri Mar 15 18:17:52 2019                            | RELEASED: Sat Mar 16 10:14:47 2019
CHART: nginx-deployment-1                                       CHART: nginx-deployment-1
USER-SUPPLIED VALUES:                                           USER-SUPPLIED VALUES:
{}                                                              {}

COMPUTED VALUES:                                                COMPUTED VALUES:
image:                                                        | {}
  repository: nginx                                           <
  tag: "1.14"                                                 <
replicaCount: 2                                               <

HOOKS:                                                          HOOKS:
MANIFEST:                                                       MANIFEST:

---                                                             ---
# Source: nginx-deployment/templates/nginx-deployment.yaml      # Source: nginx-deployment/templates/nginx-deployment.yaml
apiVersion: apps/v1                                             apiVersion: apps/v1
kind: Deployment                                                kind: Deployment
metadata:                                                       metadata:
  creationTimestamp: null                                         creationTimestamp: null
  labels:                                                         labels:
    run: nginx-deployment                                           run: nginx-deployment
  name: nginx-deployment                                          name: nginx-deployment
spec:                                                           spec:
  replicas: 2                                                 |   replicas: 1
  selector:                                                       selector:
    matchLabels:                                                    matchLabels:
      run: nginx-deployment                                           run: nginx-deployment
  strategy: {}                                                    strategy: {}
  template:                                                       template:
    metadata:                                                       metadata:
      creationTimestamp: null                                         creationTimestamp: null
      labels:                                                         labels:
        run: nginx-deployment                                           run: nginx-deployment
    spec:                                                           spec:
      containers:                                                     containers:
      - image: nginx:1.14                                     |       - image: nginx:1.9.10
        name: nginx-deployment                                          name: nginx-deployment
        resources: {}                                                   resources: {}
status: {}                                                      status: {}
```

In earlier sections , we have notices that there is no change in chart.
Its recommended to change the chart version based on the changes you make

```shell
$ vi nginx-deployment/Chart.yaml
```

Change revision from 1 to 2

```yaml
version: 2
```
