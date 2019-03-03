+++
menutitle = "Kibana"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Kibana

```yaml
cat <<EOF >kibana.yaml
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: kube-logging
  labels:
    app: kibana
spec:
  ports:
  - port: 5601
  selector:
    app: kibana
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: kube-logging
  labels:
    app: kibana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kibana
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
      - name: kibana
        image: docker.elastic.co/kibana/kibana-oss:6.4.3
        resources:
          limits:
            cpu: 1000m
          requests:
            cpu: 100m
        env:
          - name: ELASTICSEARCH_URL
            value: http://elasticsearch:9200
        ports:
        - containerPort: 5601
EOF
```

```shell
kubectl create -f kibana.yaml
```

```shell
kubectl rollout status deployment/kibana --namespace=kube-logging
```

>Output

```console
Waiting for deployment "kibana" rollout to finish: 0 of 1 updated replicas are available...
deployment "kibana" successfully rolled out
```

```
$ kubectl get pods --namespace=kube-logging
```

>Output

```
NAME                     READY   STATUS    RESTARTS   AGE
es-cluster-0             1/1     Running   0          21m
es-cluster-1             1/1     Running   0          20m
es-cluster-2             1/1     Running   0          19m
kibana-87b7b8cdd-djbl4   1/1     Running   0          72s
```

```
$ kubectl port-forward kibana-87b7b8cdd-djbl4 5601:5601 --namespace=kube-logging
```

You may use [PuTTY tunneling](https://blog.devolutions.net/2017/4/how-to-configure-an-ssh-tunnel-on-putty) to access the 127.0.0.1:5601 port
or you can use [ssh command tunneling](https://www.ssh.com/ssh/tunneling/example) if you are using Mac or Linux

After accessing the URL `http://localhost:5601` via browser , you will see the Kibana web interface

![Kibana](kibana.jpg?classes=shadow&pc=50)
