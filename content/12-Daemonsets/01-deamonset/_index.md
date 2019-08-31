+++
menutitle = "DaemonSet"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# DaemonSet

A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.

Lets imagine that we need an agent deployed on all nodes which reads the system logs and sent to a log analysis database

Here we are mimicking the agent using a simple pod.
A pod that mounts /var/log inside the pod and do tail of syslog file

```shell
$ vi logger.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: log-tailer
spec:
 volumes:
 - name: syslog
   hostPath:
    path: /var/log
 containers:
  - name: logger
    image: ansilh/debug-tools
    args:
     - /bin/sh
     - -c
     - tail -f /data/logs/syslog
    volumeMounts:
    - name: syslog
      mountPath: /data/logs/
    securityContext:
     privileged: true
```

```shell
$ kubectl create -f logger.yaml
```

Now we can execute a `logs` command to see the system log

```shell
$ kubectl logs log-tailer -f
```

```shell
$ kubectl delete pod log-tailer
```

Now we need the same kind of Pod to be running on all nodes.
If we add a node in future , the same pod should start on that node as well.

To accomplish this goal , we can use `DaemonSet`.

```shell
$ vi logger.yaml
```

```yaml
apiVersion: apps/v1                               
kind: DaemonSet                                   
metadata:                                         
 name: log-tailer                                 
spec:                                             
  selector:                                       
    matchLabels:                                  
      name: log-tailer                            
  template:                                       
    metadata:                                     
      labels:                                     
        name: log-tailer                          
    spec:                                         
      tolerations:                                
       - key: node-role.kubernetes.io/master      
         effect: NoSchedule                       
      volumes:                                    
       - name: syslog                             
         hostPath:                                
          path: /var/log                          
      containers:                                 
       - name: logger                             
         image: ansilh/debug-tools                
         args:                                    
          - /bin/sh                               
          - -c                                    
          - tail -f /data/logs/syslog             
         volumeMounts:                            
          - name: syslog                          
            mountPath: /data/logs/                
         securityContext:                         
          privileged: true                        
```

```shell
$ kubectl create -f logger.yaml
```

```shell
$ kubectl get pods -o wide
```

```console
NAME               READY   STATUS    RESTARTS   AGE   IP              NODE            NOMINATED NODE   READINESS GATES
log-tailer-hzjzx   1/1     Running   0          22s   10.10.36.242    k8s-worker-01   <none>           <none>
log-tailer-rqgrf   1/1     Running   0          22s   10.10.151.153   k8s-master-01   <none>           <none>
```

Important notes at the end of the page in this URL : https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
