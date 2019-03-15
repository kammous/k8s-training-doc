+++
menutitle = "Upgrade"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Deployment

#### Modify `values` file with below content

```
cat <<EOF >nginx-deployment/values.yaml
replicaCount: 2
image:
  repository: "nginx"
  tag: "1.14"
EOF
```

#### Modify deployment template

```shell
$ vi nginx-deployment/templates/nginx-deployment.yaml
```


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: nginx-deployment
  name: nginx-deployment
spec:
  replicas: {{ .Values.replicaCount }} # <-- This is value is referred from values.yaml `replicaCount` field
  selector:
    matchLabels:
      run: nginx-deployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: nginx-deployment
    spec:
      containers:
      - image: {{ .Values.image.repository }}:{{ .Values.image.tag }} # <-- this is self explanatory :)
        name: nginx-deployment
        resources: {}
status: {}
```

#### Lint the chart to make sure everything good.

```shell
$ helm lint ./nginx-deployment/
```

>Output

```
==> Linting ./nginx-deployment/
Lint OK

1 chart(s) linted, no failures
```


- The `REVISION` is `1` as of now.

```shell
$ helm ls
```

```properties
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
ungaged-possum  1               Fri Mar 15 16:41:28 2019        DEPLOYED        nginx-deployment-1                      default
```

#### Execute a dry-run

```shell
$ helm upgrade ungaged-possum ./nginx-deployment/   --dry-run --debug
```

>Output

```yaml
[debug] Created tunnel using local port: '43533'

[debug] SERVER: "127.0.0.1:43533"

REVISION: 2
RELEASED: Fri Mar 15 18:17:19 2019
CHART: nginx-deployment-1
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
image:
  repository: nginx
  tag: "1.14"
replicaCount: 2

HOOKS:
MANIFEST:

---
# Source: nginx-deployment/templates/nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: nginx-deployment
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      run: nginx-deployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: nginx-deployment
    spec:
      containers:
      - image: nginx:1.14
        name: nginx-deployment
        resources: {}
status: {}
Release "ungaged-possum" has been upgraded. Happy Helming!
LAST DEPLOYED: Fri Mar 15 16:41:28 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME              READY  UP-TO-DATE  AVAILABLE  AGE
nginx-deployment  1/1    1           1          95m

==> v1/Pod(related)
NAME                               READY  STATUS   RESTARTS  AGE
nginx-deployment-64f767964b-drfcc  1/1    Running  0         95m
```

#### Upgrade package

```shell
$ helm upgrade ungaged-possum ./nginx-deployment/
```

>Output

```properties
Release "ungaged-possum" has been upgraded. Happy Helming!
LAST DEPLOYED: Fri Mar 15 18:17:52 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME              READY  UP-TO-DATE  AVAILABLE  AGE
nginx-deployment  1/2    1           1          96m

==> v1/Pod(related)
NAME                               READY  STATUS   RESTARTS  AGE
nginx-deployment-64f767964b-drfcc  1/1    Running  0         96m
```

#### Verify the number of `Pods` after upgarde.

```shell
$ kubectl get pods
```

>Output

```
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-d5d56dcf9-6cxvk   1/1     Running   0          7s
nginx-deployment-d5d56dcf9-8r868   1/1     Running   0          20s
```

#### Verify the new Nginx version

```shell
$ kubectl exec nginx-deployment-d5d56dcf9-6cxvk -- nginx -v
```

>Output

```
nginx version: nginx/1.14.2
```

```shell
$ helm ls
```

>Output

```
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
ungaged-possum  2               Fri Mar 15 18:17:52 2019        DEPLOYED        nginx-deployment-1                      default
```

#### Check the helm upgrade history

```shell
$ helm history ungaged-possum
```

>Output

```
REVISION        UPDATED                         STATUS          CHART                   DESCRIPTION
1               Fri Mar 15 16:41:28 2019        SUPERSEDED      nginx-deployment-1      Install complete
2               Fri Mar 15 18:17:52 2019        DEPLOYED        nginx-deployment-1      Upgrade complete
```

#### Check the changes happened between revisions

```shell
$ sdiff <(helm get ungaged-possum --revision=1) <(helm get ungaged-possum --revision=2)
```

{{% notice note %}}
<b>Output on right hand side shows the changed values.<br>
`|` Indicates changes in line.<br>
`>` Indicates inserted lines.</b>
{{% /notice %}}

```
REVISION: 1                                                   | REVISION: 2
RELEASED: Fri Mar 15 16:41:28 2019                            | RELEASED: Fri Mar 15 18:17:52 2019
CHART: nginx-deployment-1                                       CHART: nginx-deployment-1
USER-SUPPLIED VALUES:                                           USER-SUPPLIED VALUES:
{}                                                              {}

COMPUTED VALUES:                                                COMPUTED VALUES:
{}                                                            | image:
                                                              >   repository: nginx
                                                              >   tag: "1.14"
                                                              > replicaCount: 2

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
  replicas: 1                                                 |   replicas: 2
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
      - image: nginx:1.9.10                                   |       - image: nginx:1.14
        name: nginx-deployment                                          name: nginx-deployment
        resources: {}                                                   resources: {}
status: {}                                                      status: {}
```
