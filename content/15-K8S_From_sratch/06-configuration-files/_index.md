+++
menutitle = "Configuration Files"
date = 2018-12-29T17:15:52Z
weight = 6
chapter = false
pre = "<b>- </b>"
+++

# Generating Kubernetes Configuration Files for Authentication

In this lab you will generate [Kubernetes configuration files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/), also known as kubeconfigs, which enable Kubernetes clients to locate and authenticate to the Kubernetes API Servers.

## Client Authentication Configs

In this section you will generate kubeconfig files for the `controller manager`, `kubelet`, `kube-proxy`, and `scheduler` clients and the `admin` user.

### Kubernetes Public IP Address

Each kubeconfig requires a Kubernetes API Server to connect to. To support high availability the IP address assigned to the HA-Proxy load balancer fronting the Kubernetes API Servers will be used.

Set the `lb0` virtual IP address: 192.168.78.220 as KUBERNETES_PUBLIC_ADDRESS

```
KUBERNETES_PUBLIC_ADDRESS=$(grep master /etc/hosts |awk '{print $1}')
```

### The kubelet Kubernetes Configuration File

When generating kubeconfig files for Kubelets the client certificate matching the Kubelet's node name must be used. This will ensure Kubelets are properly authorized by the Kubernetes [Node Authorizer](https://kubernetes.io/docs/admin/authorization/node/).

Generate a kubeconfig file for each worker node:

```shell
$ for instance in $(grep k8s /etc/hosts |awk '{print $2}'); do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done
```

Results:

```
$ ls -lrt *.kubeconfig
-rw------- 1 k8s k8s 6472 Feb  2 17:57 k8s-master-ah-01.kubeconfig
-rw------- 1 k8s k8s 6472 Feb  2 17:57 k8s-worker-ah-01.kubeconfig
-rw------- 1 k8s k8s 6472 Feb  2 17:57 k8s-worker-ah-02.kubeconfig
-rw------- 1 k8s k8s 6468 Feb  2 17:57 k8s-worker-ah-03.kubeconfig

```

### The kube-proxy Kubernetes Configuration File

Generate a kubeconfig file for the `kube-proxy` service:

```shell
$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}
```

Results:

```shell
$ ls -lrt kube-proxy.kubeconfig
-rw------- 1 k8s k8s 6370 Feb  2 17:58 kube-proxy.kubeconfig
```

### The kube-controller-manager Kubernetes Configuration File

Generate a kubeconfig file for the `kube-controller-manager` service:

```shell
$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}
```

Results:

```console
~$ ls -lrt kube-controller-manager.kubeconfig
-rw------- 1 k8s k8s 6411 Feb  2 18:00 kube-controller-manager.kubeconfig
```


### The kube-scheduler Kubernetes Configuration File

Generate a kubeconfig file for the `kube-scheduler` service:

```shell
$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}
```

Results:

```
$ ls -lrt kube-scheduler.kubeconfig
-rw------- 1 k8s k8s 6381 Feb  2 18:00 kube-scheduler.kubeconfig

```

### The admin Kubernetes Configuration File

Generate a kubeconfig file for the `admin` user:

```shell
$ {
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}
```

Results:

```
$ ls -lrt admin.kubeconfig
-rw------- 1 k8s k8s 6317 Feb  2 18:01 admin.kubeconfig
```

## Distribute the Kubernetes Configuration Files

Copy the appropriate `kubelet` and `kube-proxy` kubeconfig files to each worker instance:

```shell
$ for instance in $(grep k8s /etc/hosts |awk '{print $2}'); do
  scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done
```

Copy the appropriate `kube-controller-manager` and `kube-scheduler` kubeconfig files to each controller instance:

```shell
$ for instance in $(grep master /etc/hosts |awk '{print $2}'); do
  scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done
```
