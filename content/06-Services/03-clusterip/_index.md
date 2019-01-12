+++
menutitle = "ClusterIP"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Service with type `clusterIP`
It exposes the service on a cluster-internal IP.

When we expose a pod using `kubectl expose` command , we are creating a service object in API.

Choosing this value makes the service only reachable from within the cluster. **This is the default ServiceType**.

We can see the `Service` spec using `--dry-run` & `--output=yaml`

```console
$ kubectl expose pod coffee --port=80 --target-port=9090  --type=ClusterIP --dry-run --output=yaml
```
Output

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    run: coffee
  name: coffee
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 9090
  selector:
    run: coffee
  type: ClusterIP
status:
  loadBalancer: {}
```

Cluster IP service is useful when you don't want to expose the service to external world. eg:- database service.

With service names , a frontend tier can access the database backend without knowing the IPs of the Pods.

CoreDNS (kube-dns) will dynamically create a service DNS entry and that will be resolvable from Pods.

#### Verify Service DNS

Start debug-tools container which is an alpine linux image with network related binaries

```shell
$ kubectl run debugger --image=ansilh/debug-tools --restart=Never
```

```shell
$ kubectl exec -it debugger -- /bin/sh

/ # nslookup coffee
Server:         192.168.10.10
Address:        192.168.10.10#53

Name:   coffee.default.svc.cluster.local
Address: 192.168.10.86

/ # nslookup 192.168.10.86
86.10.168.192.in-addr.arpa      name = coffee.default.svc.cluster.local.

/ #
```

```properties
coffee.default.svc.cluster.local
  ^      ^      ^    k8s domain
  |      |      |  |-----------|
  |      |      +--------------- Indicates that its a service
  |      +---------------------- Namespace
  +----------------------------- Service Name
```  
