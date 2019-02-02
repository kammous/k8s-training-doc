+++
menutitle = "CA Configuration"
date = 2018-12-29T17:15:52Z
weight = 4
chapter = false
pre = "<b>- </b>"
+++

# PKI Infrastructure

We will provision a PKI Infrastructure using CloudFlare's PKI toolkit, cfssl, then use it to bootstrap a Certificate Authority,
and generate TLS certificates for the following components: etcd, kube-apiserver, kube-controller-manager, kube-scheduler, kubelet,
and kube-proxy.

## Certificate Authority

![CA](ca.jpg?class=shadow&width=70pc)

In cryptography, a certificate authority or certification authority (CA) is an entity that issues digital certificates.

- Generate CA default files (To understand the structure of CA and CSR json . We will overwrite this configs in next steps)

```shell
$ cfssl print-defaults config > ca-config.json
$ cfssl print-defaults csr > ca-csr.json
```
- Modify ca-config and ca-csr to fit your requirement

OR

- Use below commands to create ca-config and ca-csr JSON files

**CA Configuration**

```shell
$ cat <<EOF >ca-config.json
{
    "signing": {
        "default": {
            "expiry": "8760h"
        },
        "profiles": {
            "kubernetes": {
                "expiry": "8760h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF
```
**CA CSR**

```shell
$ cat <<EOF >ca-csr.json
{
    "CN": "Kubernetes",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "KL",
            "O": "Kubernetes",
            "OU": "CA",
            "ST": "Kerala"
        }
    ]
}
EOF
```

```shell
$ cfssl gencert -initca ca-csr.json |cfssljson -bare ca
```

- Output

```ruby
2018/10/01 22:03:14 [INFO] generating a new CA key and certificate from CSR
2018/10/01 22:03:14 [INFO] generate received request
2018/10/01 22:03:14 [INFO] received CSR
2018/10/01 22:03:14 [INFO] generating key: rsa-2048
2018/10/01 22:03:14 [INFO] encoded CSR
2018/10/01 22:03:14 [INFO] signed certificate with serial number 621260968886516247086480084671432552497699065843
```

- ca.pem , ca-key.pem, ca.csr files will be created , but we need only ca.pem and ca-key.pem

```shell
$ ls -lrt ca*
```

```
-rw-rw-r-- 1 k8s k8s  385 Oct  1 21:53 ca-config.json
-rw-rw-r-- 1 k8s k8s  262 Oct  1 21:56 ca-csr.json
-rw-rw-r-- 1 k8s k8s 1350 Oct  1 22:03 ca.pem
-rw------- 1 k8s k8s 1679 Oct  1 22:03 ca-key.pem
-rw-r--r-- 1 k8s k8s  997 Oct  1 22:03 ca.csr
```
