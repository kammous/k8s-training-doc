+++
menutitle = "Container Networking"
date = 2018-12-29T17:15:52Z
weight = 9
chapter = false
pre = "<b>- </b>"
+++

# Container networking - Demo

We need to access the container from outside world and the container running on different hosts have to communicate each other.

Here we will see how can we do it with bridging.

* Traditional networking
![Network](/images/nw-traditional.PNG?classes=shadow)

* Create a veth pair on Host.
```
ip link add veth0 type veth peer name veth1
ip link show
```

* Create a network namespace
```
ip netns add bash-nw-namespace
ip netns show
```

* Connect one end to namespace
```
ip link set veth1 netns bash-nw-namespace
ip link list
```
* Resulting network
![Network](/images/nw-namespace.png?classes=shadow)

* Create a Bridge interface
```
brctl addbr cbr0
```

* Add an external interface to bridge
```
brctl addif cbr0 enp0s9
brctl show
```

* Connect other end to a switch
```
brctl addif cbr0 veth0
brctl show
```
* Resulting network
![Network](/images/nw-namespace-with-bridge.png?classes=shadow)

* Assign IP to interface
```
ip netns exec bash-nw-namespace bash
ip addr add 192.168.56.10/24 dev veth1
ip link set lo up
ip link set dev veth1 up
```

* Access container IP from outside

Like bridging , we can opt other networking solutions.

Later we will see how Weave Network and Calico plugins works.
You may read bit more on Docker networking basics on below blog post

[Docker networking](https://blog.docker.com/2016/12/understanding-docker-networking-drivers-use-cases/)
