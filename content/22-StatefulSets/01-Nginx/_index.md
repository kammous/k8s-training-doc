+++
menutitle = "Nginx"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Nginx

### HeadLess service

For headless Services that do not define selectors, the endpoints controller does not create Endpoints records. However, the DNS system will create entries 
This will help application to do discovery of active pods

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
```
### Ordinal Index 

Ordinal index starts from 0 to N-1 where N is the number of replicas in spec

### Start/Stop order

For a StatefulSet with N replicas, when Pods are being deployed, they are created sequentially, in order from {0..N-1}

### Nginx StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
      storageClassName: iscsi-targetd-vg-targetd
```

### Basics 

https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/