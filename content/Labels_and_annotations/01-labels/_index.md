+++
menutitle = "Labels"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Why we need labels ?

If you have a bucket of white dominos and you want to group it based on the number of dots.

Lets say we want all dominos with 10 dots;  we will take domino one by one and if its having 10 dots ,we will put it aside and continue the same operation until all dominos were checked.

Likewise , suppose if you have 100 pods and few of them are nginx and few of them are centos , how we can see only nginx pods ?

We need a label on each pod so that we can tell `kubectl` command to show the pods with that label.

In kubernetes , label is a key value pair and it provides 'identifying metadata' for objects.
These are fundamental qualities of objects that will be used for grouping , viewing and operating.

For now we will se how we can view them (Will discuss about grouping and operation on pod groups later)

#### Pod labels

Lets run a Coffee app Pod
```shell
k8s@k8s-master-01:~$ kubectl run coffee-app --image=ansilh/demo-coffee --restart=Never
pod/coffee-app created
k8s@k8s-master-01:~$ kubectl get pods
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   1/1     Running   0          4s
k8s@k8s-master-01:~$
```

#### See the labels of a Pods
```shell
k8s@k8s-master-01:~$ kubectl get pods --show-labels
NAME         READY   STATUS    RESTARTS   AGE   LABELS
coffee-app   1/1     Running   0          37s   run=coffee-app
k8s@k8s-master-01:~$
```

As you can see above , the lables is `run=coffee-app` which is a key value pair - `key` is `run` `value` is `coffee-app`.
When we run Pod imperatively , `kubectl` ass this label to Pod.

#### Add custom label to Pod

We can add label to Pod using `kubectl label` command.
```shell
k8s@k8s-master-01:~$ kubectl label pod coffee-app app=frontend
pod/coffee-app labeled
k8s@k8s-master-01:~$
```

Here we have add a label `app=frontend` to pod `coffee-app`.

#### Use label selectors

Lets start another coffee application pod with name coffee-app02.
```shell
k8s@k8s-master-01:~$ kubectl run coffee-app02 --image=ansilh/demo-coffee --restart=Never
pod/coffee-app02 created
k8s@k8s-master-01:~$
```

Now we have two Pods.
```
k8s@k8s-master-01:~$ kubectl get pods --show-labels
NAME           READY   STATUS    RESTARTS   AGE    LABELS
coffee-app     1/1     Running   0          5m5s   app=frontend,run=coffee-app
coffee-app02   1/1     Running   0          20s    run=coffee-app02
k8s@k8s-master-01:~$
```

Lets see how can I select the Pods with label  app=frontend.
```shell
k8s@k8s-master-01:~$ kubectl get pods --selector=app=frontend
NAME         READY   STATUS    RESTARTS   AGE
coffee-app   1/1     Running   0          6m52s
k8s@k8s-master-01:~$
```

You can add as many as label you want.

We can add a prefix like `app`   ( eg: `app/dev=true` ) which is also a valid label.

|Limitations||
|-------|---|
|Prefix | DNS subdomain with 256 characters |
|Key    | 63 characters |
|Value  | 63 characters |

#### Remove labels

See the labels of  coffee-app
```shell
k8s@k8s-master-01:~$ kubectl get pods --show-labels
NAME           READY   STATUS    RESTARTS   AGE   LABELS
coffee-app     1/1     Running   0          28m   app=frontend,run=coffee-app
coffee-app02   1/1     Running   0          24m   run=coffee-app02
```

Remove the `app` label
```shell
k8s@k8s-master-01:~$ kubectl label pod coffee-app app-
pod/coffee-app labeled
```

Resulting output
```shell
k8s@k8s-master-01:~$ kubectl get pods --show-labels
NAME           READY   STATUS    RESTARTS   AGE   LABELS
coffee-app     1/1     Running   0          29m   run=coffee-app
coffee-app02   1/1     Running   0          24m   run=coffee-app02
k8s@k8s-master-01:~$
```
