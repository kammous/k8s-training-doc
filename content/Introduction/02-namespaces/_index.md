+++
menutitle = "Linux Namespaces"
date = 2018-12-29T17:15:52Z
weight = 6
chapter = false
pre = "<b>- </b>"
+++

# Namespaces in Linux

Namespaces are a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources while another set of processes sees a different set of resources. The feature works by having the same name space for these resources in the various sets of processes, but those names referring to distinct resources. Examples of resource names that can exist in multiple spaces, so that the named resources are partitioned, are process IDs, hostnames, user IDs, file names, and some names associated with network access, and interprocess communication.

Namespaces are a fundamental aspect of containers on Linux.

|Namespace   |Constant          |Isolates
|------------|------------------|--------------------
|Cgroup      |CLONE_NEWCGROUP   |Cgroup root directory
|IPC         |CLONE_NEWIPC      |System V IPC, POSIX message queues
|Network     |CLONE_NEWNET      |Network devices, stacks, ports, etc.
|Mount       |CLONE_NEWNS       |Mount points
|PID         |CLONE_NEWPID      |Process IDs
|User        |CLONE_NEWUSER     |User and group IDs
|UTS         |CLONE_NEWUTS      |Hostname and NIS domain name

The kernel assigns each process a symbolic link per namespace kind in `/proc/<pid>/ns/`. The inode number pointed to by this symlink is the same for each process in this namespace. This uniquely identifies each namespace by the inode number pointed to by one of its symlinks.

Reading the symlink via readlink returns a string containing the namespace kind name and the inode number of the namespace.
