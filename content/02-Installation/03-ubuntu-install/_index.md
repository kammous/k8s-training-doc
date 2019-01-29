+++
menutitle = "Install Ubuntu 16.04"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# Ubuntu installation

* Download Ubuntu 16.04 ISO
http://releases.ubuntu.com/16.04/ubuntu-16.04.5-server-amd64.iso

Create a template VM which will be used to clone all needed VMs

- You need at least 50GB free space to host all VMs
- All VMs will be placed in a directory called (Don't create these manually now!)
 `DRIVE_NAME:/VMs/` (Replace `DRIVE_NAME` with a mount point or Driver name)
- Install Ubuntu 16.04 with latest patches
- VM configuration  
    - VM Name : `k8s-master-01`
    - Memory  : 2 GB
    - CPU     : 2
    - Disk    : 100GB
    - HostOnly interface    : 1 (ref. step 1).
    - NAT network interface : 1

{{% notice warning %}}
By default , NAT will be the first in network adapter order , change it.
NAT interface should be the second interface and
Host-Only should be the first one
{{% /notice  %}}

- Install Ubuntu on this VM and go ahead with all default options
 - When asked, provide user name `k8s` and set password
 - Make sure to select the NAT interface as primary during installation.
 - Select below in `Software Selection` screen
  - Manual Software Selection
  - OpenSSH Server

- After restart , make sure NAT interface is up
- Login to the template VM with user `k8s` and execute below commands to install latest patches.

```shell
$ sudo apt-get update
$ sudo apt-get upgrade
```

- Poweroff template VM

```shell
$ sudo poweroff
```
#### Clone VM

You may use VirtualBox GUI to create a full clone - Preferred
You can use below commands to clone a VM - Execute it at your own risk ;)

- Open CMD and execute below commands to create all needed VMs.
  You can replace the value of `DRIVER_NAME` with a drive which is having enough free space (~50GB)
- Windows

```shell
 set DRIVE_NAME=D
 cd C:\Program Files\Oracle\VirtualBox
 VBoxManage.exe clonevm "k8s-master-01" --name "k8s-worker-01" --groups "/K8S Training" --basefolder "%DRIVE_NAME%:\VMs" --register
```

- Mac or Linux (Need to test)

```shell
 DRIVE_NAME=${HOME}
 VBoxManage clonevm "k8s-master-01" --name "k8s-worker-01" --groups "/K8S Training" --basefolder ${DRIVE_NAME}/VMs" --register
```

##### Start VMs one by one and perform below

##### Execute below steps on both master and worker nodes
- Assign IP address and make sure it comes up at boot time.

```shell
$ sudo systemctl stop networking
$ sudo vi /etc/network/interfaces
```

```properties
auto enp0s3 #<-- Make sure to use HostOnly interface (it can also be enp0s8)
iface enp0s3 inet static
    address 192.168.56.X #<--- Replace X with corresponding IP octet
    netmask 255.255.255.0
```

```shell
$ sudo systemctl restart networking
```

{{% notice note %}}
You may access the VM using the IP via SSH and can complete all remaining steps from that session (for copy paste :) )
{{% /notice %}}
- Change Host name

##### Execute below steps only on worker node

```shell
$ HOST_NAME=<host name> # <--- Replace <host name> with corresponding one
```

```shell
$ sudo hostnamectl set-hostname ${HOST_NAME} --static --transient
```

- Regenrate SSH Keys

```shell
$ sudo /bin/rm -v /etc/ssh/ssh_host_*
$ sudo dpkg-reconfigure openssh-server
```

- Change iSCSI initiator IQN

```shell
$ sudo vi /etc/iscsi/initiatorname.iscsi
```

```shell
InitiatorName=iqn.1993-08.org.debian:01:HOST_NAME  #<--- Append HostName to have unique iscsi iqn
```

- Change Machine UUID

```shell
$ sudo rm /etc/machine-id /var/lib/dbus/machine-id
$ sudo systemd-machine-id-setup
```
##### Execute below steps on both master and worker nodes

- Remove 127.0.1.1 entry from /etc/hosts

- Add needed entries in /etc/hosts

```bash
$ sudo bash -c  "cat <<EOF >>/etc/hosts
192.168.56.201 k8s-master-01
192.168.56.202 k8s-worker-01
EOF"
```

- Add public DNS incase the local one is not responding in NAT

```bash
$ sudo bash -c  "cat <<EOF >>/etc/resolvconf/resolv.conf.d/tail
nameserver 8.8.8.8
EOF"
```

- Disable swap by commenting out swap_1 LV

```shell
$ sudo vi /etc/fstab
```

```
# /dev/mapper/k8s--master--01--vg-swap_1 none            swap    sw              0       0
```

- Reboot VMs

```shell
$ sudo reboot
```

{{% notice note %}}
Do a ping test to make sure both VMs can reach each other.
{{% /notice %}}
