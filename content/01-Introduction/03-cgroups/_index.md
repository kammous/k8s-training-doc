+++
menutitle = "CGroups"
date = 2018-12-29T17:15:52Z
weight = 7
chapter = false
pre = "<b>- </b>"
+++

# CGroups

cgroups (abbreviated from control groups) is a Linux kernel feature that limits, accounts for, and isolates the resource usage (CPU, memory, disk I/O, network, etc.) of a collection of processes.

#### Resource limiting
groups can be set to not exceed a configured memory limit

#### Prioritization
Some groups may get a larger share of CPU utilization or disk I/O throughput

#### Accounting
Measures a group's resource usage, which may be used

#### Control
[Freezing](https://www.kernel.org/doc/Documentation/cgroup-v1/freezer-subsystem.txt) groups of processes, their checkpointing and restarting

You can read and explore more about cGroups in this [post](https://www.digitalocean.com/community/tutorials/how-to-limit-resources-using-cgroups-on-centos-6)
