+++
menutitle = "iSCSI Volume Provisioner"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++

# Dynamic Volume Provisioner with targetd

### Setup targetd iscsi server on CentOS 7

- Create a VM with two disks (50GB each)
- Install CentOS 7 with minimal ISO with default option.
  Select only first disk for installation

- Disable SELinux

```shell
# grep disabled /etc/sysconfig/selinux
```

>Output

```shell
SELINUX=disabled
```

- Disable firewall

```shell
systemctl disable firewalld
systemctl stop firewalld
```

- If yo are not rebooting the OS now , then make sure to disable SELinux using setenforce

```shell
setenforce 0
```

- Install `taregtd`

```shell
yum install targetd
```

- Create a volume group for `targetd`

```shell
vgcreate vg-targetd /dev/sdb
```

- Enable targetd RPC access.

```shell
vi /etc/target/targetd.yaml
```

```yaml
password: nutanix

# defaults below; uncomment and edit
# if using a thin pool, use <volume group name>/<thin pool name>
# e.g vg-targetd/pool
pool_name: vg-targetd
user: admin
ssl: false
target_name: iqn.2003-01.org.linux-iscsi.k8straining:targetd
```

- Start and enable targetd

```shell
systemctl start targetd
systemctl enable targetd
systemctl status targetd
```

>Output

```console
● target.service - Restore LIO kernel target configuration
   Loaded: loaded (/usr/lib/systemd/system/target.service; enabled; vendor preset: disabled)
   Active: active (exited) since Wed 2019-02-06 13:12:58 EST; 10s ago
 Main PID: 15795 (code=exited, status=0/SUCCESS)

Feb 06 13:12:58 iscsi.k8straining.com systemd[1]: Starting Restore LIO kernel target configuration...
Feb 06 13:12:58 iscsi.k8straining.com target[15795]: No saved config file at /etc/target/saveconfig.json, ok, exiting
Feb 06 13:12:58 iscsi.k8straining.com systemd[1]: Started Restore LIO kernel target configuration.
```

### Worker nodes

On each worker nodes

Make sure the iqn is present

```shell
$ sudo vi /etc/iscsi/initiatorname.iscsi
```

```shell
$ sudo systemctl status iscsid
$ sudo systemctl restart iscsid
```

### Download and modify storage provisioner yaml on Master node

```shell
$ kubectl create secret generic targetd-account --from-literal=username=admin --from-literal=password=nutanix
```

```shell
wget https://raw.githubusercontent.com/ansilh/kubernetes-the-hardway-virtualbox/master/config/iscsi-provisioner-d.yaml
```

```shell
vi iscsi-provisioner-d.yaml
```

Modify  `TARGETD_ADDRESS` to the targetd server address.

### Download and modify  PersistentVolumeClaim and StorageClass

```shell
wget https://raw.githubusercontent.com/ansilh/kubernetes-the-hardway-virtualbox/master/config/iscsi-provisioner-pvc.yaml
```

```shell
wget https://raw.githubusercontent.com/ansilh/kubernetes-the-hardway-virtualbox/master/config/iscsi-provisioner-class.yaml
```

```shell
vi iscsi-provisioner-class.yaml
```

```yaml
targetPortal -> 10.136.102.168
iqn -> iqn.2003-01.org.linux-iscsi.k8straining:targetd
initiators -> iqn.1993-08.org.debian:01:k8s-worker-ah-01,iqn.1993-08.org.debian:01:k8s-worker-ah-02,iqn.1993-08.org.debian:01:k8s-worker-ah-03
```

### Apply all configuration

```shell
$ kubectl create -f iscsi-provisioner-d.yaml -f iscsi-provisioner-pvc.yaml -f iscsi-provisioner-class.yaml
```

```shell
$ kubectl get all
```

```yaml
NAME                                     READY   STATUS    RESTARTS   AGE
pod/iscsi-provisioner-6c977f78d4-gxb2x   1/1     Running   0          33s
pod/nginx-deployment-76bf4969df-d74ff    1/1     Running   0          147m
pod/nginx-deployment-76bf4969df-rfgfj    1/1     Running   0          147m
pod/nginx-deployment-76bf4969df-v4pq5    1/1     Running   0          147m

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   172.168.0.1   <none>        443/TCP   4d3h

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/iscsi-provisioner   1/1     1            1           33s
deployment.apps/nginx-deployment    3/3     3            3           3h50m

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/iscsi-provisioner-6c977f78d4   1         1         1       33s
replicaset.apps/nginx-deployment-76bf4969df    3         3         3       3h50m
replicaset.apps/nginx-deployment-779fcd779f    0         0         0       155m
```

```shell
$ kubectl get pvc
```

>Output

```yaml
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS               AGE
myclaim   Bound    pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343   100Mi      RWO            iscsi-targetd-vg-targetd   4s
```

### On iscsi server

```shell
# targetcli ls
```

```yaml
Warning: Could not load preferences file /root/.targetcli/prefs.bin.
o- / ......................................................................................................................... [...]
  o- backstores .............................................................................................................. [...]
  | o- block .................................................................................................. [Storage Objects: 1]
  | | o- vg-targetd:pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343  [/dev/vg-targetd/pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 (100.0MiB) write-thru activated]
  | |   o- alua ................................................................................................... [ALUA Groups: 1]
  | |     o- default_tg_pt_gp ....................................................................... [ALUA state: Active/optimized]
  | o- fileio ................................................................................................. [Storage Objects: 0]
  | o- pscsi .................................................................................................. [Storage Objects: 0]
  | o- ramdisk ................................................................................................ [Storage Objects: 0]
  o- iscsi ............................................................................................................ [Targets: 1]
  | o- iqn.2003-01.org.linux-iscsi.k8straining:targetd ................................................................... [TPGs: 1]
  |   o- tpg1 ............................................................................................... [no-gen-acls, no-auth]
  |     o- acls .......................................................................................................... [ACLs: 3]
  |     | o- iqn.1993-08.org.debian:01:k8s-worker-ah-01 ........................................................... [Mapped LUNs: 1]
  |     | | o- mapped_lun0 ................................... [lun0 block/vg-targetd:pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 (rw)]
  |     | o- iqn.1993-08.org.debian:01:k8s-worker-ah-02 ........................................................... [Mapped LUNs: 1]
  |     | | o- mapped_lun0 ................................... [lun0 block/vg-targetd:pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 (rw)]
  |     | o- iqn.1993-08.org.debian:01:k8s-worker-ah-03 ........................................................... [Mapped LUNs: 1]
  |     |   o- mapped_lun0 ................................... [lun0 block/vg-targetd:pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 (rw)]
  |     o- luns .......................................................................................................... [LUNs: 1]
  |     | o- lun0  [block/vg-targetd:pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 (/dev/vg-targetd/pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343) (default_tg_pt_gp)]
  |     o- portals .................................................................................................... [Portals: 1]
  |       o- 0.0.0.0:3260 ..................................................................................................... [OK]
  o- loopback ......................................................................................................... [Targets: 0]
```

```shell
lvs
```

```properties
  LV                                       VG         Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home                                     centos     -wi-ao---- <41.12g
  root                                     centos     -wi-ao----  50.00g
  swap                                     centos     -wi-ao----  <7.88g
  pvc-2a484a72-2a3e-11e9-aa2d-506b8db54343 vg-targetd -wi-ao---- 100.00m
```

More details can be found in below URLs

https://github.com/kubernetes-incubator/external-storage/tree/master/iscsi/targetd
https://github.com/kubernetes-incubator/external-storage/tree/master/iscsi/targetd/kubernetes
