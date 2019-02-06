+++
menutitle = "Pre-requisites"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Pre-requisites

- Create 4 clones of `template_DO_NOT_POWER_ON`.
- Names should contain your initials for identification purpose.
- Do not change any VM parameters except name.
- Once cloning completes , start all VMs.
- If needed change VM names.
- Logon to exec VM and execute below commands

```shell
$ sudo -i
#./init.sh
```

- Set hostname on each VMs using below command

```shell
$ hostnamectl set-hostname k8s-master-ah-01 --static --transient
```

- Reboot all VMs
- Note down IP each VMs from Prism
- Create /etc/hosts entries on each VM for all VMs.

eg:-
```
10.136.102.232 k8s-master-ah-01
10.136.102.116 k8s-worker-ah-01
10.136.102.24  k8s-worker-ah-02
10.136.102.253 k8s-worker-ah-03
```
