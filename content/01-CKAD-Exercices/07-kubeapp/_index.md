+++
menutitle = "Kubeapps"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# Kubeapps

Kubeapps is a web-based UI for deploying and managing applications in Kubernetes clusters

#### Kubeapps Installation

- List present repos

```shell
$ helm repo list
```

```console
NAME    URL
stable  https://kubernetes-charts.storage.googleapis.com
local   http://127.0.0.1:8879/charts
```

- Add bitnami repo

```shell
$ helm repo add bitnami https://charts.bitnami.com/bitnami
```

"bitnami" has been added to your repositories

```shell
$ helm repo list
```

```properties
NAME    URL
stable  https://kubernetes-charts.storage.googleapis.com
local   http://127.0.0.1:8879/charts
bitnami https://charts.bitnami.com/bitnami
```

- Install Kubeapps

```shell
$ helm install --name kubeapps --namespace kubeapps bitnami/kubeapps
```

If it fails with below error , execute install one more time

```console
Error: unable to recognize "": no matches for kind "AppRepository" in version "kubeapps.com/v1alpha1"
```

```yaml
NAME:   kubeapps
LAST DEPLOYED: Sat Mar 16 11:00:08 2019
NAMESPACE: kubeapps
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                                DATA  AGE
kubeapps-frontend-config            1     0s
kubeapps-internal-dashboard-config  2     0s

==> v1/Pod(related)
NAME                                                         READY  STATUS             RESTARTS  AGE
kubeapps-6b59fbd4c5-8ggdr                                    0/1    Pending            0         0s
kubeapps-6b59fbd4c5-pbt4h                                    0/1    Pending            0         0s
kubeapps-internal-apprepository-controller-59bff895fb-tjdtb  0/1    ContainerCreating  0         0s
kubeapps-internal-chartsvc-5cc9c456fc-7r24x                  0/1    Pending            0         0s
kubeapps-internal-chartsvc-5cc9c456fc-rzgzx                  0/1    Pending            0         0s
kubeapps-internal-dashboard-6b54cd94fc-bm2st                 0/1    Pending            0         0s
kubeapps-internal-dashboard-6b54cd94fc-zskq5                 0/1    Pending            0         0s
kubeapps-internal-tiller-proxy-d584c568c-spf8m               0/1    Pending            0         0s
kubeapps-internal-tiller-proxy-d584c568c-z2skv               0/1    Pending            0         0s
kubeapps-mongodb-8694b4b9f6-jqxw2                            0/1    ContainerCreating  0         0s

==> v1/Service
NAME                            TYPE       CLUSTER-IP       EXTERNAL-IP  PORT(S)    AGE
kubeapps                        ClusterIP  172.168.130.35   <none>       80/TCP     0s
kubeapps-internal-chartsvc      ClusterIP  172.168.155.89   <none>       8080/TCP   0s
kubeapps-internal-dashboard     ClusterIP  172.168.201.176  <none>       8080/TCP   0s
kubeapps-internal-tiller-proxy  ClusterIP  172.168.20.4     <none>       8080/TCP   0s
kubeapps-mongodb                ClusterIP  172.168.84.95    <none>       27017/TCP  0s

==> v1/ServiceAccount
NAME                                        SECRETS  AGE
kubeapps-internal-apprepository-controller  1        0s
kubeapps-internal-tiller-proxy              1        0s

==> v1beta1/Deployment
NAME              READY  UP-TO-DATE  AVAILABLE  AGE
kubeapps-mongodb  0/1    1           0          0s

==> v1beta1/Role
NAME                                        AGE
kubeapps-internal-apprepository-controller  0s
kubeapps-internal-tiller-proxy              0s
kubeapps-repositories-read                  0s
kubeapps-repositories-write                 0s

==> v1beta1/RoleBinding
NAME                                        AGE
kubeapps-internal-apprepository-controller  0s
kubeapps-internal-tiller-proxy              0s

==> v1beta2/Deployment
NAME                                        READY  UP-TO-DATE  AVAILABLE  AGE
kubeapps                                    0/2    0           0          0s
kubeapps-internal-apprepository-controller  0/1    1           0          0s
kubeapps-internal-chartsvc                  0/2    0           0          0s
kubeapps-internal-dashboard                 0/2    0           0          0s
kubeapps-internal-tiller-proxy              0/2    0           0          0s


NOTES:
** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace kubeapps

Kubeapps can be accessed via port 80 on the following DNS name from within your cluster:

   kubeapps.kubeapps.svc.cluster.local

To access Kubeapps from outside your K8s cluster, follow the steps below:

1. Get the Kubeapps URL by running these commands:
   echo "Kubeapps URL: http://127.0.0.1:8080"
   export POD_NAME=$(kubectl get pods --namespace kubeapps -l "app=kubeapps" -o jsonpath="{.items[0].metadata.name}")
   kubectl port-forward --namespace kubeapps $POD_NAME 8080:8080

2. Open a browser and access Kubeapps using the obtained URL.
```

- Make sure everything is no failed objects in `kubeapps` namespace.

```shell
$ kubectl get all --namespace=kubeapps
```

```yaml
NAME                                                              READY   STATUS      RESTARTS   AGE
pod/apprepo-sync-bitnami-9f266-6ds4l                              0/1     Completed   0          54s
pod/apprepo-sync-incubator-p6fjk-q7hv2                            0/1     Completed   0          54s
pod/apprepo-sync-stable-79l58-mqrmg                               1/1     Running     0          54s
pod/apprepo-sync-svc-cat-725kn-kxvg6                              0/1     Completed   0          54s
pod/kubeapps-6b59fbd4c5-8ggdr                                     1/1     Running     0          2m15s
pod/kubeapps-6b59fbd4c5-pbt4h                                     1/1     Running     0          2m15s
pod/kubeapps-internal-apprepository-controller-59bff895fb-tjdtb   1/1     Running     0          2m15s
pod/kubeapps-internal-chartsvc-5cc9c456fc-7r24x                   1/1     Running     0          2m15s
pod/kubeapps-internal-chartsvc-5cc9c456fc-rzgzx                   1/1     Running     0          2m15s
pod/kubeapps-internal-dashboard-6b54cd94fc-bm2st                  1/1     Running     0          2m15s
pod/kubeapps-internal-dashboard-6b54cd94fc-zskq5                  1/1     Running     0          2m15s
pod/kubeapps-internal-tiller-proxy-d584c568c-spf8m                1/1     Running     0          2m15s
pod/kubeapps-internal-tiller-proxy-d584c568c-z2skv                1/1     Running     0          2m15s
pod/kubeapps-mongodb-8694b4b9f6-jqxw2                             1/1     Running     0          2m15s

NAME                                     TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)     AGE
service/kubeapps                         ClusterIP   172.168.130.35    <none>        80/TCP      2m15s
service/kubeapps-internal-chartsvc       ClusterIP   172.168.155.89    <none>        8080/TCP    2m15s
service/kubeapps-internal-dashboard      ClusterIP   172.168.201.176   <none>        8080/TCP    2m15s
service/kubeapps-internal-tiller-proxy   ClusterIP   172.168.20.4      <none>        8080/TCP    2m15s
service/kubeapps-mongodb                 ClusterIP   172.168.84.95     <none>        27017/TCP   2m15s

NAME                                                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kubeapps                                     2/2     2            2           2m15s
deployment.apps/kubeapps-internal-apprepository-controller   1/1     1            1           2m15s
deployment.apps/kubeapps-internal-chartsvc                   2/2     2            2           2m15s
deployment.apps/kubeapps-internal-dashboard                  2/2     2            2           2m15s
deployment.apps/kubeapps-internal-tiller-proxy               2/2     2            2           2m15s
deployment.apps/kubeapps-mongodb                             1/1     1            1           2m15s

NAME                                                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/kubeapps-6b59fbd4c5                                     2         2         2       2m15s
replicaset.apps/kubeapps-internal-apprepository-controller-59bff895fb   1         1         1       2m15s
replicaset.apps/kubeapps-internal-chartsvc-5cc9c456fc                   2         2         2       2m15s
replicaset.apps/kubeapps-internal-dashboard-6b54cd94fc                  2         2         2       2m15s
replicaset.apps/kubeapps-internal-tiller-proxy-d584c568c                2         2         2       2m15s
replicaset.apps/kubeapps-mongodb-8694b4b9f6                             1         1         1       2m15s

NAME                                     COMPLETIONS   DURATION   AGE
job.batch/apprepo-sync-bitnami-9f266     1/1           53s        54s
job.batch/apprepo-sync-incubator-p6fjk   1/1           54s        54s
job.batch/apprepo-sync-stable-79l58      0/1           54s        54s
job.batch/apprepo-sync-svc-cat-725kn     1/1           13s        54s

NAME                                   SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/apprepo-sync-bitnami     0 * * * *   False     0        <none>          54s
cronjob.batch/apprepo-sync-incubator   0 * * * *   False     0        <none>          54s
cronjob.batch/apprepo-sync-stable      0 * * * *   False     0        <none>          54s
cronjob.batch/apprepo-sync-svc-cat     0 * * * *   False     0        <none>          54s
```

- Access Kubeapps dashboard
(My API server's insecure port is listening on 8080 port , so I had to use 8081 for port-forwarding)

```shell
$ export POD_NAME=$(kubectl get pods --namespace kubeapps -l "app=kubeapps" -o jsonpath="{.items[0].metadata.name}")
$ kubectl port-forward --namespace kubeapps $POD_NAME 8080:8081
```

- Start an tunnel to 127.0.0.1:8081 using SSH via the host
- Access Web GUI

![Kubeapps](login.jpg?classes=shadow)

- Create a service account for Kubeapps login

```shell
$ kubectl create serviceaccount kubeapps-operator
$ kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
```

- Retrieve token

```shell
$ kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{.secrets[].name}') -o jsonpath='{.data.token}' | base64 --decode
```

- Use this token to login

![KubeApps](after-login.jpg?classes=shadow)

- Click on `Catalog` to see all Helm charts from upstream repositories.

![Catalog](catalog.jpg?classes=shadow)
