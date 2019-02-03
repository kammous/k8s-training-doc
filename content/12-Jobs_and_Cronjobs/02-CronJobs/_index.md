+++
menutitle = "CronJob"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# CronJob

```shell
$ kubectl run date-print --image=ansilh/debug-tools  --restart=OnFailure  --schedule="* * * * *" -- /bin/sh -c date

k8s@k8s-master-ah-01:~$ kubectl get cronjobs.batch
NAME         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
date-print   * * * * *   False     0        <none>          7s
k8s@k8s-master-ah-01:~$ kubectl get pods
No resources found.
k8s@k8s-master-ah-01:~$

k8s@k8s-master-ah-01:~$ kubectl get cronjobs.batch
NAME         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
date-print   * * * * *   False     0        22s             60s
k8s@k8s-master-ah-01:~$ kubectl get pods
NAME                          READY   STATUS      RESTARTS   AGE
date-print-1549217580-qmjxt   0/1     Completed   0          36s
k8s@k8s-master-ah-01:~$

k8s@k8s-master-ah-01:~$ kubectl logs date-print-1549217580-qmjxt
Sun Feb  3 18:13:08 UTC 2019
```
