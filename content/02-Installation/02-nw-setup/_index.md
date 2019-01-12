+++
menutitle = "VirtualBox Network"
date = 2018-12-29T17:15:52Z
weight = 6
chapter = false
pre = "<b>- </b>"
+++

# VirtualBox network configuration
- Create HostOnly network ( Default will be 192.168.56.0/24)
  - Open Virtual Box
  - Got to menu and navigate to File ->Host Network Manager
  - Then click "Create"
 This will create a Host-Only Network.

 DHCP should be disabled on this network.

 Internet access is needed on all VMs (for downloading needed binaries).

 Make sure you can see the NAT network.(If not , create one).


| VBox Host Networking |      
|---------------|--------------
| HostOnly      | 192.168.56.0/24
| NAT           | VBOX Defined
