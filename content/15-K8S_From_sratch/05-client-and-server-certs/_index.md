+++
menutitle = "Client and Server Certificates"
date = 2018-12-29T17:15:52Z
weight = 5
chapter = false
pre = "<b>- </b>"
+++

# Client and Server Certificates

In this section you will generate client and server certificates for each Kubernetes component and a client certificate for
the Kubernetes admin user.

### The Admin Client Certificate (This will be used for `kubectl` command)
```shell
$ {

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

$ cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

}
```

Results:
```console
admin-key.pem
admin.pem
```

### The Kubelet Client Certificates

Kubernetes uses a [special-purpose authorization mode](https://kubernetes.io/docs/admin/authorization/node/) called Node Authorizer, that specifically authorizes API requests made by [Kubelets](https://kubernetes.io/docs/concepts/overview/components/#kubelet). In order to be authorized by the Node Authorizer, Kubelets must use a credential that identifies them as being in the `system:nodes` group, with a username of `system:node:<nodeName>`. In this section you will create a certificate for each Kubernetes worker node that meets the Node Authorizer requirements.

Generate a certificate and private key for each Kubernetes worker node:

```shell
$ for instance in $(cat /etc/hosts| grep k8s |awk '{print $2}'); do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF



cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
```

Results:

```
$ ls -lrt k8s*
-rw-rw-r-- 1 k8s k8s  268 Feb  2 16:54 k8s-master-ah-01-csr.json
-rw-rw-r-- 1 k8s k8s  268 Feb  2 16:54 k8s-worker-ah-01-csr.json
-rw-rw-r-- 1 k8s k8s 1513 Feb  2 16:54 k8s-master-ah-01.pem
-rw------- 1 k8s k8s 1679 Feb  2 16:54 k8s-master-ah-01-key.pem
-rw-r--r-- 1 k8s k8s 1082 Feb  2 16:54 k8s-master-ah-01.csr
-rw-rw-r-- 1 k8s k8s 1513 Feb  2 16:54 k8s-worker-ah-01.pem
-rw------- 1 k8s k8s 1679 Feb  2 16:54 k8s-worker-ah-01-key.pem
-rw-r--r-- 1 k8s k8s 1082 Feb  2 16:54 k8s-worker-ah-01.csr
-rw-rw-r-- 1 k8s k8s  268 Feb  2 16:54 k8s-worker-ah-02-csr.json
-rw-rw-r-- 1 k8s k8s  268 Feb  2 16:54 k8s-worker-ah-03-csr.json
-rw-rw-r-- 1 k8s k8s 1513 Feb  2 16:54 k8s-worker-ah-02.pem
-rw------- 1 k8s k8s 1679 Feb  2 16:54 k8s-worker-ah-02-key.pem
-rw-r--r-- 1 k8s k8s 1082 Feb  2 16:54 k8s-worker-ah-02.csr
-rw-rw-r-- 1 k8s k8s 1513 Feb  2 16:54 k8s-worker-ah-03.pem
-rw------- 1 k8s k8s 1675 Feb  2 16:54 k8s-worker-ah-03-key.pem
-rw-r--r-- 1 k8s k8s 1082 Feb  2 16:54 k8s-worker-ah-03.csr

```

### The Controller Manager Client Certificate

Generate the `kube-controller-manager` client certificate and private key:

```
{

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}
```

Results:

```
$ ls -lrt kube-controller*
-rw-rw-r-- 1 k8s k8s  270 Feb  2 16:55 kube-controller-manager-csr.json
-rw-rw-r-- 1 k8s k8s 1472 Feb  2 16:55 kube-controller-manager.pem
-rw------- 1 k8s k8s 1675 Feb  2 16:55 kube-controller-manager-key.pem
-rw-r--r-- 1 k8s k8s 1086 Feb  2 16:55 kube-controller-manager.csr

```


### The Kube Proxy Client Certificate

Generate the `kube-proxy` client certificate and private key:

```
{

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

}
```

Results:

```
$ ls -lrt kube-proxy*
-rw-rw-r-- 1 k8s k8s  257 Feb  2 16:55 kube-proxy-csr.json
-rw-rw-r-- 1 k8s k8s 1456 Feb  2 16:55 kube-proxy.pem
-rw------- 1 k8s k8s 1675 Feb  2 16:55 kube-proxy-key.pem
-rw-r--r-- 1 k8s k8s 1070 Feb  2 16:55 kube-proxy.csr

```

### The Scheduler Client Certificate

Generate the `kube-scheduler` client certificate and private key:

```
{

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}
```

Results:

```
$ ls -lrt kube-scheduler*
-rw-rw-r-- 1 k8s k8s  261 Feb  2 16:56 kube-scheduler-csr.json
-rw-rw-r-- 1 k8s k8s 1460 Feb  2 16:56 kube-scheduler.pem
-rw------- 1 k8s k8s 1679 Feb  2 16:56 kube-scheduler-key.pem
-rw-r--r-- 1 k8s k8s 1074 Feb  2 16:56 kube-scheduler.csr

```
### The Kubernetes API Server Certificate

IP address will be included in the list of subject alternative names for the Kubernetes API Server certificate. This will ensure the certificate can be validated by remote clients.

Generate the Kubernetes API Server certificate and private key:

```
{

KUBERNETES_ADDRESS="$(grep k8s /etc/hosts |awk '{print $1}' | sed ':a;N;$!ba;s/\n/,/g'),172.168.0.1"

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${KUBERNETES_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

}
```

Results:

```
$ ls -lrt kubernetes*
-rw-rw-r-- 1 k8s k8s  240 Feb  2 17:01 kubernetes-csr.json
-rw-rw-r-- 1 k8s k8s 1501 Feb  2 17:01 kubernetes.pem
-rw------- 1 k8s k8s 1675 Feb  2 17:01 kubernetes-key.pem
-rw-r--r-- 1 k8s k8s 1045 Feb  2 17:01 kubernetes.csr

```

## The Service Account Key Pair

The Kubernetes Controller Manager leverages a key pair to generate and sign service account tokens as describe in the [managing service accounts](https://kubernetes.io/docs/admin/service-accounts-admin/) documentation.

Generate the `service-account` certificate and private key:

```
{

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Bangalore",
      "O": "system:masters",
      "OU": "Kubernetes from Scratch",
      "ST": "Karnataka"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

}
```

Results:

```
$ ls -lrt service-account*
-rw-rw-r-- 1 k8s k8s  246 Feb  2 17:02 service-account-csr.json
-rw-rw-r-- 1 k8s k8s 1440 Feb  2 17:02 service-account.pem
-rw------- 1 k8s k8s 1679 Feb  2 17:02 service-account-key.pem
-rw-r--r-- 1 k8s k8s 1054 Feb  2 17:02 service-account.csr

```

## Distribute the Client and Server Certificates

Enable SSH key authentication from master node to all worker nodes to transfer files.

- Generate a key

```shell
$ ssh-keygen
```

- Copy key to remote systems

```shell
$ for instance in $(grep k8s /etc/hosts |awk '{print $2}'); do (ssh-copy-id ${instance}); done
```

- Copy the appropriate certificates and private keys to each worker instance:

```shell
$ for instance in $(grep k8s /etc/hosts |awk '{print $2}'); do
  scp kubernetes-key.pem kubernetes.pem ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
done
```

Copy the appropriate certificates and private keys to each controller instance:

```shell
$ for instance in $(grep master /etc/hosts |awk '{print $2}'); do
  scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem ${instance}:~/
done
```

```shell
$ for instance in $(grep k8s /etc/hosts |awk '{print $2}'); do
  scp /etc/hosts ${instance}:~/
done
```

> The `kube-proxy`, `kube-controller-manager`, `kube-scheduler`, and `kubelet` client certificates will be used to generate client authentication configuration files in the next lab.
