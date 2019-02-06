+++
menutitle = "CronJob"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# CronJob

CronJob is another abstraction of Job , which will create Job objects periodically based on the mentioned schedule.
The schedule notation is taken from Linux cron scheduler

```shell
$ kubectl run date-print --image=ansilh/debug-tools  --restart=OnFailure  --schedule="* * * * *" -- /bin/sh -c date
```

```
$ kubectl get cronjobs.batch
```

```
NAME         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
date-print   * * * * *   False     0        <none>          7s
```

```
$ kubectl get pods
```

```
No resources found.
```

```
$ kubectl get cronjobs.batch
```

```
NAME         SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
date-print   * * * * *   False     0        22s             60s
```

```
$ kubectl get pods
NAME                          READY   STATUS      RESTARTS   AGE
date-print-1549217580-qmjxt   0/1     Completed   0          36s
```

```
$ kubectl logs date-print-1549217580-qmjxt
```

```
Sun Feb  3 18:13:08 UTC 2019
```


#### Concurrency Policy
The ``.spec.concurrencyPolicy` field is also optional.

It specifies how to treat concurrent executions of a job that is created by this cron job. the spec may specify only one of the following concurrency policies:

`Allow` (default): The cron job allows concurrently running jobs

`Forbid`: The cron job does not allow concurrent runs; if it is time for a new job run and the previous job run hasn’t finished yet, the cron job skips the new job run

`Replace`: If it is time for a new job run and the previous job run hasn’t finished yet, the cron job replaces the currently running job run with a new job run

Note that concurrency policy only applies to the jobs created by the same cron job.


https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/
