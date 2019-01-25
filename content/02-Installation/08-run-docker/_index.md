+++
menutitle = "Run a Docker container"
date = 2018-12-29T17:15:52Z
weight = 12
chapter = false
pre = "<b>- </b>"
+++

# Container management using Docker

#### Start a Container
- Here we map port 80 of host to port 9090 of cotainer
- Verify application from browser
- Press Ctrl+c to exit container

```shell
$ docker run -p 80:9090 ansilh/demo-webapp
```

- Start a Container in detach mode

```shell
$ docker run -d -p 80:9090 ansilh/demo-webapp
```

- List Container

```shell
$ docker ps
CONTAINER ID        IMAGE                COMMAND             CREATED             STATUS              PORTS                  NAMES
4c8364e0d031        ansilh/demo-webapp   "/demo-webapp"      11 seconds ago      Up 10 seconds       0.0.0.0:80->9090/tcp   zen_gauss
```

- List all containers including stopped containers

```shell
$ docker ps -a
CONTAINER ID        IMAGE                COMMAND             CREATED             STATUS                     PORTS                  NAMES
4c8364e0d031        ansilh/demo-webapp   "/demo-webapp"      2 minutes ago       Up 2 minutes               0.0.0.0:80->9090/tcp   zen_gauss
acb01851c20a        ansilh/demo-webapp   "/demo-webapp"      2 minutes ago       Exited (2) 2 minutes ago                          condescending_antonelli
```

- List resource usage (Press Ctrl+c to exit)

```shell
$ docker stats zen_gauss
```

- Stop Container

```shell
$ docker stop zen_gauss
```

- List images

```shell
$ docker images
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
ansilh/demo-webapp   latest              b7c5e17ae85e        8 minutes ago       4.81MB
```

- Remove containers

```shell
$ docker rm zen_gauss
```

- Delete images

```shell
$ docker rmi ansilh/demo-webapp
```
