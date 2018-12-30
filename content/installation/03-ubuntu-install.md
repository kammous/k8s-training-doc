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
    - NAT network interface : 1
    - HostOnly interface    : 1 (ref. step 1).

NAT interface should be the first interface and Host-Only should be second

- Install Ubuntu on this VM and go ahead with all default options
 - When asked, provide user name `k8s` and set password
 - Select below in `Software Selection` screen
  - Manual Software Selection
  - OpenSSH Server

- After restart , make sure NAT interface is up
- Login to the template VM with user `k8s` and execute below commands to install latest patches.
```
$ sudo apt-get update
$ sudo apt-get upgrade
```
- Poweroff template VM
```
$ sudo poweroff
```
- Open CMD and execute below commands to create all needed VMs.
  You can replace the value of `DRIVER_NAME` with a drive which is having enough free space (~50GB)
- Windows
```
 set DRIVE_NAME=D
 cd C:\Program Files\Oracle\VirtualBox
 VBoxManage.exe clonevm "k8s-master-01" --name "k8s-worker-01" --groups "/K8S Training" --basefolder "%DRIVE_NAME%:\VMs" --register
```

- Mac or Linux (Need to test)
```
 DRIVE_NAME=${HOME}
 VBoxManage clonevm "k8s-master-01" --name "k8s-worker-01" --groups "/K8S Training" --basefolder ${DRIVE_NAME}/VMs" --register
```

##### Start VMs one by one and perform below

- IP Address and Hostname for each VMs
```
192.168.78.201 k8s-master-01
192.168.78.202 k8s-worker-01
```

- Assign IP address and make sure it comes up at boot time.
```
sudo systemctl stop networking
sudo vi /etc/network/interfaces
```
```
auto enp0s8
iface enp0s8 inet static
    address 192.168.78.X #<--- Replace X with corresponding IP octect
    netmask 255.255.255.0
```
```
sudo systemctl restart networking
```

- You may access the VM using the IP via SSH and can complete all remaining steps from that session (for copy paste :) )
- Change Host name
```
HOST_NAME=<host name> # <--- Replace <host name> with corresponding one
sudo hostnamectl set-hostname ${HOST_NAME} --static --transient
```
- Regenrate SSH Keys
```
sudo /bin/rm -v /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
```
- Change iSCSI initiator IQN
```
sudo vi /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1993-08.org.debian:01:HOST_NAME  #<--- Append HostName to have unique iscsi iqn
```  
- Change Machine UUID
```
sudo rm /etc/machine-id /var/lib/dbus/machine-id
sudo systemd-machine-id-setup
```
- Add needed entries in /etc/hosts
```
sudo bash -c  "cat <<EOF >>/etc/hosts
192.168.78.201 k8s-master-01
192.168.78.202 k8s-worker-01
EOF"
```

- Disable swap by commenting out swap_1 LV
```
sudo vi /etc/fstab
```
```
# /dev/mapper/k8s--master--01--vg-swap_1 none            swap    sw              0       0
```
- Reboot VM
```
sudo reboot
```
- Repeat the steps above for second VM
- Do a ping test to make sure all VMs can reach each other.
