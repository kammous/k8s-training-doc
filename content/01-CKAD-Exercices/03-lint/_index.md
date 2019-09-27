+++
menutitle = "Lint"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Helm Lint


#### Linting

Helm lint will help to correct and standardize the package format

```shell
$ helm lint ./helm-nginx-pkg/
```

```
==> Linting ./helm-nginx-pkg/
[ERROR] Chart.yaml: directory name (helm-nginx-pkg) and chart name (nginx-deployment) must be the same
[INFO] Chart.yaml: icon is recommended
[INFO] values.yaml: file does not exist

Error: 1 chart(s) linted, 1 chart(s) failed
```

#### Lets correct the errors

```shell
$ mv helm-nginx-pkg nginx-deployment
```
- Add an icon path (we will see where its used later)

```yaml
cat <<EOF >>nginx-deployment/Chart.yaml
icon: "https://img.icons8.com/nolan/64/000000/linux.png"
EOF
```

- Create `values.yaml` (we will see the use of this file later)

```shell
$ touch nginx-deployment/values.yaml
```

- Lint the package again

```shell
$ helm lint ./nginx-deployment
```

>Output

```
==> Linting ./nginx-deployment
Lint OK

1 chart(s) linted, no failures
```

This time we see a perfect "OK"
