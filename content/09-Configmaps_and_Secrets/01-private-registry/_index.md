+++
menutitle = "Setup a Private registry"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++


# Private Registry

All container images that we used in past examples are downloaded from docker hub public registry.
But in a production environment , we use private image registries so that we will have better control of application lifecycle.

In this session , we will deploy a private registry using `Portus`

### Download `docker-compose` binary
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

### Clone Portus git repository
$ git clone https://github.com/SUSE/Portus.git

### Start the environment with `docker-compose`
$ cd Portus
$ docker-compose up

It will take some time to download and deploy all needed containers.
