+++
menutitle = "Swagger - UI"
date = 2018-12-29T17:15:52Z
weight = 2
chapter = false
pre = "<b>- </b>"
+++


# Swagger API explorer

### Enable swagger

We can enable swagger UI in API Server

- Added --enable-swagger-ui=true to API manifest file /etc/kubernetes/manifests/kube-apiserver.yaml (only applicable to kubeadm deployments )
- Save the file
- API pod will restart itself
- Make sure API server pod is up
```console
$ kubectl get pods -n kube-system  |grep kube-apiserver
kube-apiserver-k8s-master-01            1/1     Running   0          55s
```
- Enable API proxy access
```console
$ kubectl proxy --port=8080
```
- Open an SSH tunnel from local system to server port 8080
- Access API swagger UI using webbrowser using URL `http://localhost:8080/swagger-ui/`
![Swagger UI](swagger-ui.png?classes=shadow&width=60pc)
![Swagger UI](swagger-ui-1.png?classes=shadow&width=60pc)

Note: Swagger UI is very slow because of the design of Swagger itself.
Kubernetes may drop Swagger UI from API server.
[Github Issue](https://github.com/kubernetes/kubernetes/issues/65346)

You can read more about API [here](https://kubernetes.io/docs/reference/)
