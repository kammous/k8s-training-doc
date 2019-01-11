+++
menutitle = "InitContainer"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# InitContainer
![InitContainer](initcontainer.png?classes=shadow&width=30pc)
In this session , we will discuss about InitContainer

### Non-persistent web server

As we already know ,containers are ephemeral and the modifications will be lost when container is destroyed.

In this example , we will download webpages from Github repository and store it in a `emptyDir` volume.

From this emptyDir volume , we will serve the HTML pages using an Nginx Pod

`emptyDir` is a volume type , just like hostPath , but the contents of `emptyDir` will be destroyed when Pod is stopped.

So lets write a Pod specification for Nginx container and add InitContainer to download HTML page

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
  initContainers:
  - image: ansilh/debug-tools
    name: git-pull
    args:
    - git
    - clone
    - https://github.com/ansilh/k8s-demo-web.git
    - /html/.
    volumeMounts:
    - name: html
      mountPath: /html/
```

Problem with this design is , no way to pull the changes once Pod is up.
InitContainer run only once during the startup of the Pod.

Incase of InitContainer failure , Pod startup will fail and never start other containers.

We can specify more than one initcontainer if needed.
Startup of initcontainer will be sequential and the order will be selected based on the order in yaml spec.

In next session , we will discuss about other design patterns for Pod.
