+++
menutitle = "Pod design patterns"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Pod design patterns

When the containers have the exact same lifecycle, or when the containers must run on the same node. The most common scenario is that you have a helper process that needs to be located and managed on the same node as the primary container.

Another reason to combine containers into a single pod is for simpler communication between containers in the pod. These containers can communicate through shared volumes (writing to a shared file or directory) and through inter-process communication (semaphores or shared memory).

There are three common design patterns and use-cases for combining multiple containers into a single pod. We’ll walk through the `sidecar` pattern, the `adapter` pattern, and the `ambassador` pattern.

### Example #1: Sidecar containers
Sidecar containers extend and enhance the “main” container, they take existing containers and make them better.  As an example, consider a container that runs the Nginx web server.  Add a different container that syncs the file system with a git repository, share the file system between the containers and you have built Git push-to-deploy.

![Pod Design](sidecar.png?classes=shadow)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: demo-web
  name: demo-web
spec:
  volumes:
  - name: html
    emptyDir: {}
  containers:
  - image: nginx
    name: demo-web
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
  - image: ansilh/debug-tools
    name: git-pull
    args:
    - sh
    - -c
    - 'while true ; do [ ! -d /html/.git ] && git  clone https://github.com/ansilh/k8s-demo-web.git /html/ || { cd /html; git pull; } ; date; sleep 5 ; done'
    volumeMounts:
    - name: html
      mountPath: /html/
```

Lets do a tail on the `logs` and see how the `git-pull` works
```shell
$ kubectl logs demo-web git-pull -f
Cloning into '/html'...
Fri Jan 11 20:39:25 UTC 2019
Already up to date.
Fri Jan 11 20:39:31 UTC 2019
```
Lets modify the WebPage and push the changes to Github

```console
Already up to date.
Fri Jan 11 20:44:04 UTC 2019
From https://github.com/ansilh/k8s-demo-web
   e2df24f..1791ee1  master     -> origin/master
Updating e2df24f..1791ee1
Fast-forward
 images/pic-k8s.jpg | Bin 0 -> 14645 bytes
 index.html         |   4 ++--
 2 files changed, 2 insertions(+), 2 deletions(-)
 create mode 100644 images/pic-k8s.jpg
Fri Jan 11 20:44:10 UTC 2019
Already up to date.
```

### Example #2: Ambassador containers
Ambassador containers proxy a local connection to the world.  As an example, consider a Redis cluster with read-replicas and a single write master.  You can create a Pod that groups your main application with a Redis ambassador container.  The ambassador is a proxy is responsible for splitting reads and writes and sending them on to the appropriate servers.  Because these two containers share a network namespace, they share an IP address and your application can open a connection on “localhost” and find the proxy without any service discovery.  As far as your main application is concerned, it is simply connecting to a Redis server on localhost.  This is powerful, not just because of separation of concerns and the fact that different teams can easily own the components, but also because in the development environment, you can simply skip the proxy and connect directly to a Redis server that is running on localhost.

![Pod Design](ambassador.png?classes=shadow)

### Example #3: Adapter containers
Adapter containers standardize and normalize output.  Consider the task of monitoring N different applications.  Each application may be built with a different way of exporting monitoring data. (e.g. JMX, StatsD, application specific statistics) but every monitoring system expects a consistent and uniform data model for the monitoring data it collects.  By using the adapter pattern of composite containers, you can transform the heterogeneous monitoring data from different systems into a single unified representation by creating Pods that groups the application containers with adapters that know how to do the transformation.  Again because these Pods share namespaces and file systems, the coordination of these two containers is simple and straightforward.

![Pod Design](adapter.png?classes=shadow)
