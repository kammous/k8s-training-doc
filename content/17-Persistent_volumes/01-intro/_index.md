+++
menutitle = "Introduction"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Persistent Volumes and Related components

The `PersistentVolume` subsystem provides an API for users and administrators that abstracts details of how storage is provided from how it is consumed.

To do this we introduce two new API resources: `PersistentVolume` and `PersistentVolumeClaim`

A `PersistentVolume` (PV) is a piece of storage in the cluster that has been provisioned by an administrator.
It is a resource in the cluster just like a node is a cluster resource.
PVs are volume plugins like Volumes, but have a lifecycle independent of any individual pod that uses the PV.
This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.

A `PersistentVolumeClaim` (PVC) is a request for storage by a user.
It is similar to a pod. Pods consume node resources and PVCs consume PV resources.
Pods can request specific levels of resources (CPU and Memory).
Claims can request specific size and access modes (e.g., can be mounted once read/write or many times read-only).

A `StorageClass` provides a way for administrators to describe the “classes” of storage they offer.
Different classes might map to quality-of-service levels, or to backup policies, or to arbitrary policies determined by the cluster administrators.
Kubernetes itself is unopinionated about what classes represent. This concept is sometimes called “profiles” in other storage systems.

![Dynamic Volumes](intro.jpg?classes=shadow)
Lets follow a basic example outlined below
https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
