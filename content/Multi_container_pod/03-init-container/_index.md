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
 name: web-app-with-initcontainer
 labels:
  run: web-app-with-initcontainer
spec:
 volumes:
 - name: "website"
   emptyDir:{}
 containers:
 - name: nginx
   image: nginx
   volumeMounts:
   - name: "website"
     mountPath: "/usr/share/nginx/html"
  initContainers:
  - name: "git-sync"
   
```
