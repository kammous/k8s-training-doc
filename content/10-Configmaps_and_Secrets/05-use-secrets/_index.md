+++
menutitle = "Use Secret in Pods"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Secrets

### Using secrets

We can use secrets as environmental variable as well as mounts inside a Pod

##### Injecting as environmental variable
```shell
$ vi pod-secret.yaml
```

```yaml
apiVersion: v1       
kind: Pod
metadata:
  labels:
    run: debugger    
  name: debugger     
spec:     
  containers:        
  - image: ansilh/debug-tools   
    name: debugger   
    env:  
    - name: USER     
      valueFrom:     
       secretKeyRef:
        name: my-secret         
        key: user    
    - name: PASSWORD
      valueFrom:     
       secretKeyRef:
        name: my-secret         
        key: password
```

```shell
$ kubectl create -f pod-secret.yaml
```

```console
$ kubectl get pods      
NAME       READY   STATUS    RESTARTS   AGE   
debugger   1/1     Running   0          17s   
```

Logon to container and verify the environmental variables

```shell
$ kubectl exec -it debugger -- /bin/sh
```

Verify environment variables inside Pod

```console
/ # echo $USER        
root       
/ # echo $PASSWORD    
mypassword
/ #        
```

Delete the Pod

```shell
$ kubectl delete pod debugger
```

##### Mounting as files using volumes
```shell
$ vi pod-secret.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: debugger
  name: debugger
spec:
  volumes:
  - name: secret
    secret:
     secretName: my-secret
  containers:
  - image: ansilh/debug-tools
    name: debugger
    volumeMounts:
    - name: secret
      mountPath: /data
```

```shell
$ kubectl create -f pod-secret.yaml
```

```shell
$ kubectl exec -it debugger -- /bin/sh
```

```console
/ # cd /data        
/data #             
/data # cat user    
root                
/data # cat password
mypassword          
/data #             
```
