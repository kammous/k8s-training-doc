+++
menutitle = "Inject data to Pod"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Inject data to pod via Environmental variable

We will create a Coffee Pod
```shell
$ kubectl run tea --image=ansilh/demo-tea --env=MY_NODE_NAME=scratch --restart=Never --dry-run -o yaml >pod-with-env.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: tea
  name: tea
spec:
  containers:
  - env:
    - name: MY_NODE_NAME
      value: scratch
    image: ansilh/demo-tea
    name: coffee-new
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```

Lets run this Pod
```shell
$ kubectl create -f pod-with-env.yaml
```

```shell
$ kubectl get pods
NAME         READY   STATUS              RESTARTS   AGE
tea          1/1     Running   0          7s
```

Lets expose the pod as `NodePort`

```shell
$ kubectl expose pod tea --port=80 --target-port=8080 --type=NodePort
```

```shell
$ kubectl get svc tea
NAME   TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
tea    NodePort   192.168.10.37   <none>        80:32258/TCP   42s
```

Access the service using browser uisng node IP and port `32258`

You will see below in Page
`Node:scratch`

### Expose Pod fields to containers

Lets extract the `nodeName` from spec ( Excuse me ? yeah we will see that in a moment )

```shell
k8s@k8s-master-01:~$ kubectl get pods tea -o=jsonpath='{.spec.nodeName}' && echo
k8s-worker-01
k8s@k8s-master-01:~$ kubectl get pods tea -o=jsonpath='{.status.hostIP}' && echo
192.168.56.202
k8s@k8s-master-01:~$ kubectl get pods tea -o=jsonpath='{.status.podIP}' && echo
10.10.1.23
k8s@k8s-master-01:~$
```

To get the JSON path , first we need to get the entire object output in JSON.
We have used output in `YAML` so far because its easy . But internally `kubectl` convers `YAML` to `JSON`

```shell
$ kubectl get pod tea -o json
```

```yaml
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "annotations": {
            "cni.projectcalico.org/podIP": "10.10.1.23/32"
        },
        "creationTimestamp": "2019-01-06T15:09:36Z",
        "labels": {
            "run": "tea"
        },
        "name": "tea",
        "namespace": "default",
        "resourceVersion": "218696",
        "selfLink": "/api/v1/namespaces/default/pods/tea",
        "uid": "14c1715b-11c5-11e9-9f0f-0800276a1bd2"
    },
    "spec": {
        "containers": [
            {
                "env": [
                    {
                        "name": "MY_NODE_NAME",
                        "value": "scratch"
                    }
                ],
                "image": "ansilh/demo-tea",
                "imagePullPolicy": "Always",
                "name": "coffee-new",
                "resources": {},
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "default-token-72pzg",
                        "readOnly": true
                    }
                ]
            }
        ],
        "dnsPolicy": "ClusterFirst",
        "enableServiceLinks": true,
        "nodeName": "k8s-worker-01",
        "priority": 0,
        "restartPolicy": "Never",
        "schedulerName": "default-scheduler",
        "securityContext": {},
        "serviceAccount": "default",
        "serviceAccountName": "default",
        "terminationGracePeriodSeconds": 30,
        "tolerations": [
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/not-ready",
                "operator": "Exists",
                "tolerationSeconds": 300
            },
            {
                "effect": "NoExecute",
                "key": "node.kubernetes.io/unreachable",
                "operator": "Exists",
                "tolerationSeconds": 300
            }
        ],
        "volumes": [
            {
                "name": "default-token-72pzg",
                "secret": {
                    "defaultMode": 420,
                    "secretName": "default-token-72pzg"
                }
            }
        ]
    },
    "status": {
        "conditions": [
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2019-01-06T15:09:36Z",
                "status": "True",
                "type": "Initialized"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2019-01-06T15:09:42Z",
                "status": "True",
                "type": "Ready"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2019-01-06T15:09:42Z",
                "status": "True",
                "type": "ContainersReady"
            },
            {
                "lastProbeTime": null,
                "lastTransitionTime": "2019-01-06T15:09:36Z",
                "status": "True",
                "type": "PodScheduled"
            }
        ],
        "containerStatuses": [
            {
                "containerID": "docker://291a72e7fdab6a9f7afc47c640126cf596f5e071903b6a9055b44ef5bcb1c104",
                "image": "ansilh/demo-tea:latest",
                "imageID": "docker-pullable://ansilh/demo-tea@sha256:998d07a15151235132dae9781f587ea4d2822c62165778570145b0f659dda7bb",
                "lastState": {},
                "name": "coffee-new",
                "ready": true,
                "restartCount": 0,
                "state": {
                    "running": {
                        "startedAt": "2019-01-06T15:09:42Z"
                    }
                }
            }
        ],
        "hostIP": "192.168.56.202",
        "phase": "Running",
        "podIP": "10.10.1.23",
        "qosClass": "BestEffort",
        "startTime": "2019-01-06T15:09:36Z"
    }
}
```

Remove below from `pod-with-env.yaml`

```yaml
  - name: MY_NODE_NAME
    value: scratch
```

Add below Pod spec
```yaml
- name: MY_NODE_NAME
  valueFrom:
   fieldRef:
    fieldPath: spec.nodeName
```

Resulting Pod Yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: tea
  name: tea
spec:
  containers:
  - env:
    - name: MY_NODE_NAME
      valueFrom:
       fieldRef:
        fieldPath: spec.nodeName
    image: ansilh/demo-tea
    name: coffee-new
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```

Delete the running pod files
```shell
$ kubectl delete pod tea
```

Create  the pod with modified yaml file
```shell
$ kubectl create -f pod-with-env.yaml
```

Make sure `endpoint` is up in `service`

```shell
$ kubectl get ep tea
NAME   ENDPOINTS         AGE
tea    10.10.1.26:8080   31m
```
Refresh the browser page. This time you will see `Node:k8s-worker-01`

Lets do a cleanup on `default` namespace.
```shell
$ kubectl delete --all pods
$ kubectl delete --all services
```


Now you know
- How to use export Objects in Yaml and Json format
- How to access each fields using `jsonpath`
- How to inject environmental variables to `Pod`
- How to inject system generated fields to `Pod` using environmental variables
