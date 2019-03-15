+++
menutitle = "Installation"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Installation

#### Download Helm binaries

- Go to `https://github.com/helm/helm/releases`
- Copy download location from `Installation and Upgrading` section.

```shell
$ wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.0-linux-amd64.tar.gz
```
####  Extract tarball

```shell
$ tar -xvf helm-v2.13.0-linux-amd64.tar.gz
```

####  Configure `Helm` client.

```shell
$ sudo mv linux-amd64/helm /usr/local/bin/helm
$ helm version
```

>Output

```
Client: &version.Version{SemVer:"v2.13.0", GitCommit:"79d07943b03aea2b76c12644b4b54733bc5958d6", GitTreeState:"clean"}
Error: could not find tiller
```

####  Helm Server side configuration - Tiller

```yaml
cat <<EOF >tiller-rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
```
```shell
$ kubectl create -f tiller-rbac.yaml
```

```shell
$ helm init --service-account tiller
```

>Output

```
Creating /home/k8s/.helm
Creating /home/k8s/.helm/repository
Creating /home/k8s/.helm/repository/cache
Creating /home/k8s/.helm/repository/local
Creating /home/k8s/.helm/plugins
Creating /home/k8s/.helm/starters
Creating /home/k8s/.helm/cache/archive
Creating /home/k8s/.helm/repository/repositories.yaml
Adding stable repo with URL: https://kubernetes-charts.storage.googleapis.com
Adding local repo with URL: http://127.0.0.1:8879/charts
$HELM_HOME has been configured at /home/k8s/.helm.

Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.

Please note: by default, Tiller is deployed with an insecure 'allow unauthenticated users' policy.
To prevent this, run `helm init` with the --tiller-tls-verify flag.
For more information on securing your installation see: https://docs.helm.sh/using_helm/#securing-your-helm-installation
Happy Helming!
```

```shell
$ kubectl get pods -n kube-system |grep tiller
```

>Output

```
tiller-deploy-5b7c66d59c-8t7pc               1/1     Running   0          36s
```
