+++
menutitle = "Security Context"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Security Context

### Configure a Security Context for a Pod or Container

A security context defines privilege and access control settings for a Pod or Container. Security context settings include:

- Discretionary Access Control: Permission to access an object, like a file, is based on user ID (UID) and group ID (GID).

- Security Enhanced Linux (SELinux): Objects are assigned security labels.

- Running as privileged or unprivileged.

- Linux Capabilities: Give a process some privileges, but not all the privileges of the root user.

- AppArmor: Use program profiles to restrict the capabilities of individual programs.

- Seccomp: Filter a process’s system calls.

- AllowPrivilegeEscalation: Controls whether a process can gain more privileges than its parent process. This bool directly controls whether the no_new_privs flag gets set on the container process. AllowPrivilegeEscalation is true always when the container is: 1) run as Privileged OR 2) has CAP_SYS_ADMIN

```yaml
cat <<EOF >secure-debugger.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secure-debugger
  name: secure-debugger
spec:
  volumes:
  - name: sec-vol
    emptyDir: {}
  securityContext:
   runAsUser: 1000
   fsGroup: 2000
  containers:
  - image: ansilh/debug-tools
    name: secure-debugger
    volumeMounts:
    - name: sec-vol
      mountPath: /data/sec
    securityContext:
     allowPrivilegeEscalation: false
EOF
```     
{{% notice note %}}
**`fsGroup`: Volumes that support ownership management are modified to be owned and writable by the GID specified in fsGroup**
{{% /notice %}}
```shell
$ kubectl create -f secure-debugger.yaml
```

```shell
$ kubectl exec -it secure-debugger -- /bin/sh
/ $ id
uid=1000 gid=0(root) groups=2000
/ $ ls -ld /data/sec/
drwxrwsrwx    2 root     2000          4096 Feb 26 17:54 /data/sec/
/ $ cd /data/sec/
/data/sec $ touch test_file
/data/sec $ ls -lrt
total 0
-rw-r--r--    1 1000     2000             0 Feb 26 17:54 test_file
/data/sec $
```

To apply capabilities , we can use below in each containers.

```yaml
securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
```        

You may read more about capabilities [here](http://man7.org/linux/man-pages/man7/capabilities.7.html)

{{% notice note %}}
Read [more](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
{{% /notice %}}
