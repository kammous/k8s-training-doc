+++
menutitle = "Introduction to Volumes"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Persistent volumes

When a Pod dies , all container's contents will be destroyed and never preserved by default.
Sometimes you need to store the contents persistently (for eg:- etcd pod)

Kubernetes have a `Volumes` filed in Pod spec , which can be used to mount a volume inside container.

![volumes](volumes.png?classes=shadow)

Lets explain the volume specs

```shell
$ kubectl explain pod.spec.volumes
```

So when you write Yaml , you have to put `volumes` object in `spec`. As we have seen , `volumes` type is `<[]Object>` ; means its an array

So the contents below volumes should start with a dash "-".
Name is a mandatory field , so lets write those.
```yaml
spec:
 volumes:
 - name: "data"
```

We will use `hostPath` for now
```yaml
$ kubectl explain pod.spec.volumes.hostPath
KIND:     Pod
VERSION:  v1

RESOURCE: hostPath <Object>

DESCRIPTION:
     HostPath represents a pre-existing file or directory on the host machine
     that is directly exposed to the container. This is generally used for
     system agents or other privileged things that are allowed to see the host
     machine. Most containers will NOT need this. More info:
     https://kubernetes.io/docs/concepts/storage/volumes#hostpath

     Represents a host path mapped into a pod. Host path volumes do not support
     ownership management or SELinux relabeling.

FIELDS:
   path <string> -required-
     Path of the directory on the host. If the path is a symlink, it will follow
     the link to the real path. More info:
     https://kubernetes.io/docs/concepts/storage/volumes#hostpath

   type <string>
     Type for HostPath Volume Defaults to "" More info:
     https://kubernetes.io/docs/concepts/storage/volumes#hostpath

k8s@k8s-master-01:~$
```

Host path needs a path on the host , so lets add that as well to the `spec`

```yaml
spec:
 volumes:
 - name: "data"
   hostPath:
    path: "/var/data"
```

This will add a volume to `Pod`

Now we have to tell the pods to use it.

In `containers` specification, we have `volumeMounts` field which can be used to `mount` the `volume`.

```yaml
$ kubectl explain pod.spec.containers.volumeMounts
KIND:     Pod
VERSION:  v1

RESOURCE: volumeMounts <[]Object>

DESCRIPTION:
     Pod volumes to mount into the container's filesystem. Cannot be updated.

     VolumeMount describes a mounting of a Volume within a container.

FIELDS:
   mountPath    <string> -required-
     Path within the container at which the volume should be mounted. Must not
     contain ':'.

   mountPropagation     <string>
     mountPropagation determines how mounts are propagated from the host to
     container and the other way around. When not set, MountPropagationNone is
     used. This field is beta in 1.10.

   name <string> -required-
     This must match the Name of a Volume.

   readOnly     <boolean>
     Mounted read-only if true, read-write otherwise (false or unspecified).
     Defaults to false.

   subPath      <string>
     Path within the volume from which the container's volume should be mounted.
     Defaults to "" (volume's root).

```

`volumeMounts` is `<[]Object>` . `mountPath` is required and `name`

`name` must match the Name of a `Volume`

Resulting `Pod` `spec` will become ;

```yaml
spec:
 volumes:
 - name: "data"
   hostPath:
    path: "/var/data"
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: "data"
      mountPath: "/usr/share/nginx/html"
```

Lets add the basic fields to complete the Yaml and save the file as `nginx.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: nginx-pod01
spec:
 volumes:
 - name: "data"
   hostPath:
    path: "/var/data"
 containers:
 - name: nginx
   image: nginx
   volumeMounts:
   - name: "data"
     mountPath: "/usr/share/nginx/html"
```

Create the `Pod`
```shell
kubectl create -f nginx.yaml
```
Check where its running.
```
$ kubectl get pods -o wide
NAME          READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
nginx-pod01   1/1     Running   0          55s   10.10.1.27   k8s-worker-01   <none>           <none>
```

Lets expose this Pod first.

```shell
$ kubectl expose pod nginx-pod01 --port=80 --target-port=80 --type=NodePort
```

```properties
error: couldn't retrieve selectors via --selector flag or introspection: the pod has no labels and cannot be exposed
See 'kubectl expose -h' for help and examples.
```

This indicates that we didn't add `label` , because the `service` needs a label to map the Pod to `endpoint`

Lets add a label to the Pod.
```
$ kubectl label pod nginx-pod01 run=nginx-pod01
```

Now we can we can expose the Pod

```
$ kubectl expose pod nginx-pod01 --port=80 --target-port=80 --type=NodePort
```

Get the node port which service is listening to

```
$ kubectl get svc nginx-pod01
NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-pod01   NodePort   192.168.10.51   <none>        80:31538/TCP   26s
```

You will get `403 Forbidden` page , because there is no html page to load.

Now we can go to the node where the Pod is running and check the path `/var/data`

```console
k8s@k8s-worker-01:~$ ls -ld /var/data
drwxr-xr-x 2 root root 4096 Jan  7 00:52 /var/data
k8s@k8s-worker-01:~$ cd /var/data
k8s@k8s-worker-01:/var/data$ ls -lrt
total 0
k8s@k8s-worker-01:/var/data$
```

Nothing is there.The directory is owned by root , so you have to create the file `index.html` with root.
```console
k8s@k8s-worker-01:/var/data$ sudo -i
[sudo] password for k8s:
root@k8s-worker-01:~# cd /var/data
root@k8s-worker-01:/var/data#
root@k8s-worker-01:/var/data# echo "This is a test page" >index.html
root@k8s-worker-01:/var/data#
```
Reload the web page and you should see "This is a test page"

Now you know;
- How to create a volume.
- How to mount a volume.
- How to access the contents of volume from host.
