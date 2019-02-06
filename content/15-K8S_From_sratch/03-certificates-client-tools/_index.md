+++
menutitle = "Tools"
date = 2018-12-29T17:15:52Z
weight = 3
chapter = false
pre = "<b>- </b>"
+++

# Tools Installation

#### 1. Install cfssl to generate certificates
```shell
$ wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
```

```shell
$ chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
```

```shell
$ sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
```

```shell
$ sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
```

- Verification

```shell
$ cfssl version
```

- Output

```console
Version: 1.2.0
Revision: dev
Runtime: go1.6
```

#### 2. Install kubectl
- Download `kubectl`

```shell
wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl
```

- Make it executable and move to one of the shell `$PATH`

```shell
$ chmod +x kubectl
$ sudo mv kubectl /usr/local/bin/
```

- Verification

```shell
$ kubectl version --client
```

- Output

```console
Client Version: version.Info{Major:"1", Minor:"12", GitVersion:"v1.12.0", GitCommit:"0ed33881dc4355495f623c6f22e7dd0b7632b7c0", GitTreeState:"clean", BuildDate:"2018-09-27T17:05:32Z", GoVersion:"go1.10.4", Compiler:"gc", Platform:"linux/amd64"}
```
