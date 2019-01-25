+++
menutitle = "Build a Docker image"
date = 2018-12-29T17:15:52Z
weight = 11
chapter = false
pre = "<b>- </b>"
+++

# Build Docker image using Dockerfile

Create a [Docker Hub account](https://hub.docker.com/)

- Let’s create a directory to store the Dockerfile

```shell
$ mkdir ~/demo-webapp
```

- Copy the pre-built program

```shell
$ cp $GOPATH/bin/demo-webapp ~/demo-webapp/
```

- Create a Dockerfile.

```shell
$ cd ~/demo-webapp/
$ vi Dockerfile
```

```
FROM scratch
LABEL maintainer="Ansil H"
LABEL email="ansilh@gmail.com"
COPY demo-webapp /
CMD ["/demo-webapp"]
```

- Build the docker image

```shell
$ sudo docker build -t <docker login name>/demo-webapp .
Eg:-
$ sudo docker build -t ansilh/demo-webapp .
```

- Login to Docker Hub using your credentials

```shell
$ docker login
```

- Push image to Docker hub

```shell
$ docker push <docker login name>/demo-webapp
Eg:-
$ docker push ansilh/demo-webapp
```

Congratulations ! . Now the image you built is available in Docker Hub and we can use this image to run containers in upcoming sessions
