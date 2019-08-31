+++
menutitle = "Pre-requisites"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Pre-requisites

- Install an Ubuntu 16.04 VM and create 4 clones from it.
- Make sure to create a user called `k8s` which will be used in upcoming steps.
- Names should contain your initials for identification purpose if you are using a shared environment.
- Do not change any VM parameters except name while cloning.
- Once cloning completes , start all VMs.
- Make sure to give the hostname with prefix `k8s-master-` for Master and `k8s-worker-` for worker
  If you miss this , then the scripts/command may fail down the line.
- Create a shell script `init.sh` on each VM and execute it as mentioned below.

```bash
cat <<EOF >init.sh
#!/usr/bin/env bash
disable_ipv6(){
echo "[INFO] Disabling IPv6"
 sysctl -w net.ipv6.conf.all.disable_ipv6=1
 sysctl -w net.ipv6.conf.default.disable_ipv6=1
 sysctl -w net.ipv6.conf.lo.disable_ipv6=1

 cat <<EOF >>/etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
}

regenerate_uuid(){
echo "[INFO] Regenerating machine UUID"
 rm /etc/machine-id /var/lib/dbus/machine-id
 systemd-machine-id-setup
}

regenerate_ssh_keys(){
echo "[INFO] Regenerating SSH Keys"
 /bin/rm -v /etc/ssh/ssh_host_*
 dpkg-reconfigure openssh-server
}

regenerate_iscsi_iqn(){
echo "[INFO] Changing iSCSI InitiatorName"
 echo "InitiatorName=iqn.1993-08.org.debian:01:$(openssl rand -hex 4)" >/etc/iscsi/initiatorname.iscsi
}

disable_ipv6
regenerate_uuid
regenerate_ssh_keys
regenerate_iscsi_iqn
EOF
```
- Give execution permission and execute it using `sudo`

```shell
$ chmod 755 init.sh
$ sudo ./init.sh
```
- Set hostname on each VMs
  eg:- For master

```shell
$ hostnamectl set-hostname k8s-master-ah-01 --static --transient
```
- Reboot all VMs once host names were set.
- Note down IP each VMs from Prism
- Create /etc/hosts entries on each VM for all VMs.

eg:-
```
10.136.102.232 k8s-master-ah-01
10.136.102.116 k8s-worker-ah-01
10.136.102.24  k8s-worker-ah-02
10.136.102.253 k8s-worker-ah-03
```
