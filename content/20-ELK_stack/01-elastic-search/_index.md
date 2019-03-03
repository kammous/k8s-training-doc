+++
menutitle = "Elastic Search"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Elastic Search

We will create volumes with hostpath for testing purposes.
In production , we will use PVs from a volume provisioner or we will use dynamic volume provisioning

- Create volumes according to the number of nodes

```yaml
cat <<EOF >es-volumes-manual.yaml
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-001
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data01"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-002
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data02"
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-003
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/tmp/data03"
---
EOF
```

```shell
$ kubectl create -f es-volumes-manual.yaml
```

```shell
$ kubectl get pv
```

>Output

```console
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                     STORAGECLASS   REASON   AGE
pv-001           50Gi       RWO            Retain           Available                             manual                  8s
pv-002           50Gi       RWO            Retain           Available                             manual                  8s
pv-003           50Gi       RWO            Retain           Available                             manual                  8s
```

Create a namespace

```yaml
cat <<EOF >kube-logging.yaml
kind: Namespace
apiVersion: v1
metadata:
  name: kube-logging
EOF
```

```shell
kubectl create -f kube-logging.yaml
```

- Create a headless service

```yaml
cat <<EOF >es-service.yaml
kind: Service
apiVersion: v1
metadata:
  name: elasticsearch
  namespace: kube-logging
  labels:
    app: elasticsearch
spec:
  selector:
    app: elasticsearch
  clusterIP: None
  ports:
    - port: 9200
      name: rest
    - port: 9300
      name: inter-node
EOF
```

```shell
kubectl create -f es-service.yaml
```

Create stateful set

```yaml
cat <<EOF >es_statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: es-cluster
  namespace: kube-logging
spec:
  serviceName: elasticsearch
  replicas: 3
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - name: elasticsearch
        image: docker.elastic.co/elasticsearch/elasticsearch-oss:6.4.3
        resources:
            limits:
              cpu: 1000m
            requests:
              cpu: 100m
        ports:
        - containerPort: 9200
          name: rest
          protocol: TCP
        - containerPort: 9300
          name: inter-node
          protocol: TCP
        volumeMounts:
        - name: data
          mountPath: /usr/share/elasticsearch/data
        env:
          - name: cluster.name
            value: k8s-logs
          - name: node.name
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: discovery.zen.ping.unicast.hosts
            value: "es-cluster-0.elasticsearch,es-cluster-1.elasticsearch,es-cluster-2.elasticsearch"
          - name: discovery.zen.minimum_master_nodes
            value: "2"
          - name: ES_JAVA_OPTS
            value: "-Xms512m -Xmx512m"
      initContainers:
      - name: fix-permissions
        image: busybox
        command: ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: data
          mountPath: /usr/share/elasticsearch/data
      - name: increase-vm-max-map
        image: busybox
        command: ["sysctl", "-w", "vm.max_map_count=262144"]
        securityContext:
          privileged: true
      - name: increase-fd-ulimit
        image: busybox
        command: ["sh", "-c", "ulimit -n 65536"]
        securityContext:
          privileged: true
  volumeClaimTemplates:
  - metadata:
      name: data
      labels:
        app: elasticsearch
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: manual
      resources:
        requests:
          storage: 50Gi
EOF
```

```shell
kubectl create -f es_statefulset.yaml
```

- Montor StatefulSet rollout status

```shell
kubectl rollout status sts/es-cluster --namespace=kube-logging
```

- Verify elastic search cluster by checking the state

Forward the pod port 9200 to localhost port 9200
```
$ kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging
```

Execute curl command to see the cluster state.
Here , master node is `'J0ZQqGI0QTqljoLxh5O3-A'` , which is `es-cluster-0`

```json
curl http://localhost:9200/_cluster/state?pretty
{
  "cluster_name" : "k8s-logs",
  "compressed_size_in_bytes" : 358,
  "cluster_uuid" : "ahM0thu1RSKQ5CXqZOdPHA",
  "version" : 3,
  "state_uuid" : "vDwLQHzJSGixU2AItNY1KA",
  "master_node" : "J0ZQqGI0QTqljoLxh5O3-A",
  "blocks" : { },
  "nodes" : {
    "jZdz75kSSSWDpkIHYoRFIA" : {
      "name" : "es-cluster-1",
      "ephemeral_id" : "flfl4-TURLS_yTUOlZsx5g",
      "transport_address" : "10.10.151.186:9300",
      "attributes" : { }
    },
    "J0ZQqGI0QTqljoLxh5O3-A" : {
      "name" : "es-cluster-0",
      "ephemeral_id" : "qXcnM2V1Tcqbw1cWLKDkSg",
      "transport_address" : "10.10.118.123:9300",
      "attributes" : { }
    },
    "pqGu-mcNQS-OksmiJfCUJA" : {
      "name" : "es-cluster-2",
      "ephemeral_id" : "X0RtmusQS7KM5LOy9wSF3Q",
      "transport_address" : "10.10.36.224:9300",
      "attributes" : { }
    }
  },
snippned..
```
