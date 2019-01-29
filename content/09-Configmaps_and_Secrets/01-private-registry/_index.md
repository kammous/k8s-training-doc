+++
menutitle = "Setup a Private registry"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++


# Private Registry using Harbor

![Harbor](harbor.jpg)

All container images that we used in past examples are downloaded from docker hub public registry.
But in a production environment , we use private image registries so that we will have better control of application lifecycle.

In this session , we will deploy a private registry using **`Harbor`**

Students needs to deploy this in a separate VM (4GB memmory + 2vCPUs). If you are attending live session , then instructor will provide private registry credential.

### Download `docker-compose` binary
```console
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
### Clone Portus git repository
```shell
$ sudo curl https://storage.googleapis.com/harbor-releases/release-1.7.0/harbor-offline-installer-v1.7.1.tgz -O
```

```shell
$ tar -xvf harbor-offline-installer-v1.7.1.tgz
```

#### Mandatory configuration

Go to the extracted directory

```shell
$ cd harbor
```

Edit configuration file `harbor.cfg`

```
$ vi harbor.cfg
```

Change `hostname` to the server's FQDN . Make sure you have proper name resolution in place or create an entry in `/etc/hosts`
Change `ui_url_protocol` from `http` to `https`

### Start the environment with `docker-compose`
```
$ docker-compose up -d
```
It will take some time to download and deploy all needed containers.

Once all services were up , access the registry using FQDN or IP

Default username & password is **admin/Harbor12345**
![Harbor](harbor-page.jpg)
