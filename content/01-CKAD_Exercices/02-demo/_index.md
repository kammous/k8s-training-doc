+++
menutitle = "A Minimal Package"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# A Minimal Package

In this demo , we will create an Nginx deployment with one replica.
This demo is like more or less applying a deployment yaml . But in upcoming sessions we will see how we can leverage helm to customize the deployment without modifying yaml specs.

####  Create a demo helm-nginx-pkg package

```shell
$ mkdir helm-nginx-pkg
```

- Create a `templates` directory.

```shell
$ mkdir helm-nginx-pkg/templates
```

####  Create a deployment yaml inside `templates` diretory.

```shell
$ kubectl run nginx-deployment --image=nginx:1.9.10 --dry-run -o yaml >helm-nginx-pkg/templates/nginx-deployment.yaml
```

####  Create a Chart.yaml (https://helm.sh/docs/developing_charts/#the-chart-yaml-file)

```yaml
cat <<EOF >helm-nginx-pkg/Chart.yaml
apiVersion: v1
name: nginx-deployment
version: 1
description: Demo Helm chart to deploy Nginx
maintainers:
  - name: "Ansil H"
    email: "ansilh@gmail.com"
    url: "https://ansilh.com"
EOF
```

#### `inspect` the chart and see the details of package.

```shell
$ helm inspect chart ./helm-nginx-pkg/
```

```yaml
apiVersion: v1
description: Demo Helm chart to deploy Nginx
maintainers:
- email: ansilh@gmail.com
  name: Ansil H
  url: https://ansilh.com
name: nginx-deployment
version: "1"
```

#### Dry-run install to see everything works or not

```shell
$ helm install ./helm-nginx-pkg  --debug --dry-run
```

>Output

```yaml
[debug] Created tunnel using local port: '43945'

[debug] SERVER: "127.0.0.1:43945"

[debug] Original chart version: ""
[debug] CHART PATH: /home/k8s/helm-nginx-pkg

NAME:   alliterating-crab
REVISION: 1
RELEASED: Fri Mar 15 14:13:59 2019
CHART: nginx-deployment-1
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
{}

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
  replicas: 1
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
      - image: nginx:1.9.10
        name: nginx-deployment
        resources: {}
status: {}
```

####  To verify nothing is created as part of dry-run

```shell
$ helm ls
```

####  Install package

```shell
$ helm install ./helm-nginx-pkg
```

>Output

```yaml
NAME:   filled-toad
LAST DEPLOYED: Fri Mar 15 14:15:50 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME              READY  UP-TO-DATE  AVAILABLE  AGE
nginx-deployment  0/1    0           0          0s

==> v1/Pod(related)
NAME                               READY  STATUS   RESTARTS  AGE
nginx-deployment-64f767964b-qj9t9  0/1    Pending  0         0s


$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-64f767964b-qj9t9   1/1     Running   0          16s
```

####  List deployed charts

```shell
$ helm ls
```

>Output

```console
NAME       	REVISION	UPDATED                 	STATUS  	CHART             	APP VERSION	NAMESPACE
filled-toad	1       	Fri Mar 15 14:15:50 2019	DEPLOYED	nginx-deployment-1	           	default
```

```shell
$ kubectl get pods
```

>Output

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-64f767964b-drfcc   1/1     Running   0          21s
```
