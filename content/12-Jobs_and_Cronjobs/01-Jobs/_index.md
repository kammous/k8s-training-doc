+++
menutitle = "Jobs"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Job

A job creates one or more pods and ensures that a specified number of them successfully terminate.
As pods successfully complete, the job tracks the successful completions.

When a specified number of successful completions is reached, the job itself is complete.

Deleting a Job will cleanup the pods it created.

- Start a Job to print date

```shell
$ kubectl run date-print --image=ansilh/debug-tools  --restart=OnFailure  -- /bin/sh -c date
```

```shell
$ kubectl get jobs
```

>Output

```
NAME         COMPLETIONS   DURATION   AGE
date-print   0/1           3s         3s
```

```
$ kubectl get pods
```

>Output

```
NAME               READY   STATUS      RESTARTS   AGE
date-print-psxw6   0/1     Completed   0          8s
```

```
$ kubectl get jobs
```

>Output

```
NAME         COMPLETIONS   DURATION   AGE
date-print   1/1           4s         10s
```

```
$ kubectl logs date-print-psxw6
```

>Output

```
Sun Feb  3 18:10:45 UTC 2019
```

To control the number of failure and restart , we can use `spec.backoffLimit`

To start n number of pods that will run in sequential order , we can use ``.spec.completions`

To start multiple pods in parallel , we can use `.spec.parallelism`

To cleanup the completed Jobs automatically , we can use `ttlSecondsAfterFinished` (1.12 alpha feature)



https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/
