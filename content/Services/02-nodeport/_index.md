+++
menutitle = "NodePort"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# NodePort

NodePort Exposes the service on each Node’s IP at a static port (the NodePort). A ClusterIP service, to which the NodePort service will route, is automatically created. You’ll be able to contact the NodePort service, from outside the cluster, by requesting <NodeIP>:<NodePort>.

#### How `nodePort` works

![NodePort](pod-service-nodeport.png?classes=shadow)

kube-proxy watches the Kubernetes master for the addition and removal of Service and Endpoints objects.

(We will discuss about `Endpoints` later in this session.)

For each `Service`,  it opens a port (randomly chosen) on the local node. Any connections to this “proxy port” will be proxied to one of the Service’s backend Pods (as reported in Endpoints). Lastly, it installs iptables rules which capture traffic to the Service’s `clusterIP` (which is virtual) and Port and redirects that traffic to the proxy port which proxies the backend Pod.

#### `nodePort` workflow.

1. `nodePort` -> `30391`

2. `port` -> `80`

3. `targetPort` -> `9090`
