+++
menutitle = "Continers"
date = 2018-12-29T17:15:52Z
weight = 8
chapter = false
pre = "<b>- </b>"
+++

# Container From Scratch

Using namespaces , we can start a process which will be completely isolated from other processes running in the system.

### Create root File System

* Create directory to store rootfs contents
```
mkdir -p /root/busybox/rootfs
CONTAINER_ROOT=/root/busybox/rootfs
cd ${CONTAINER_ROOT}
```

* Download busybox binary
```
wget https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64
```

* Create needed directories and symlinks
```
mv busybox-x86_64 busybox
chmod 755 busybox
mkdir bin
mkdir proc
mkdir sys
mkdir tmp
for i in $(./busybox --list)
do
   ln -s /busybox bin/$i
done
```

### Start Container

* Start a shell in new contianer
```
unshare --mount --uts --ipc --net --pid --fork --user --map-root-user chroot ${CONTAINER_ROOT} /bin/sh
```

* Mount essential kernel structures
```
mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs none /tmp
```

### Configure networking

* From Host system , create a veth pair and then map that to container
```
# ip link add vethlocal type veth  peer name vethNS
# ip link set vethlocal up
# ip link set vethNS up
# ps -ef |grep '/bin/sh'
# ip link set vethNS netns <pid of /bin/sh>
```

* From container , execute `ip link`
