+++
menutitle = "Kubernetes"
date = 2018-12-29T17:15:52Z
weight = 11
chapter = false
pre = "<b>- </b>"
+++

# Kubernetes

Pet vs Cattle.

In the pets service model, each pet server is given a loving names like zeus, ares, hades, poseidon, and athena. They are “unique, lovingly hand-raised, and cared for, and when they get sick, you nurse them back to health”. You scale these up by making them bigger, and when they are unavailable, everyone notices.

In the cattle service model, the servers are given identification numbers like web-01, web-02, web-03, web-04, and web-05, much the same way cattle are given numbers tagged to their ear. Each server is “almost identical to each other” and “when one gets sick, you replace it with another one”. You scale these by creating more of them, and when one is unavailable, no one notices.


Kubernetes is a portable, extensible open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available.

Google open-sourced the Kubernetes project in 2014. Kubernetes builds upon a decade and a half of experience that Google has with running production workloads at scale, combined with best-of-breed ideas and practices from the community

[Read More here](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)

![Container and Kubernetes](kubernetes.svg?classes=shadow&width=60pc)


### Kubernetes Architecture

![Container and Kubernetes](kubernetes-architecture.png?classes=shadow)

#### Container runtime

Docker , rkt , containerd or any OCI compliant runtime which will download image , configures network , mount volumes and assist container life cycle management.

#### kubelet

Responsible for instructing container runtime to start , stop or modify a container

#### kube-proxy

Manage service IPs and iptables rules

#### kube-apiserver

API server interacts with all other components in cluster
All client interactions will happen via API server

#### kube-scheduler

Responsible for scheduling workload on minions or worker nodes based on resource constraints

#### kube-controller-manager

Responsible for monitoring different containers in reconciliation loop
Will discuss more about different controllers later in this course

#### etcd

Persistent store where we store all configurations and cluster state

#### cloud-controller-manager

Cloud vendor specific controller and cloud vendor is Responsible to develop this program
