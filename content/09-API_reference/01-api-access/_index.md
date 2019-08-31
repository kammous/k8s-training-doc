+++
menutitle = "API Access"
date = 2018-12-29T17:15:52Z
weight = 1
chapter = false
pre = "<b>- </b>"
+++

# Kubernetes API

Lets explore how API defines and organizes objects

## API organization

API is organized to two groups , one is `Core` group and second on is `Named Groups`

### Core Group

Contains all stable and core API objects

#### `/api` (APIVersions)
This endpoint will return core API version & API address itself

Execute below commands if you are using Vagrant based setup
If you are using `kubeadm` based setup , then skip this.

```shell
$ sudo mkdir -p /etc/kubernetes/pki/
$ sudo cp /home/vagrant/PKI/ca.pem /etc/kubernetes/pki/ca.crt
$ sudo cp /home/vagrant/PKI/k8s-master-01.pem /etc/kubernetes/pki/apiserver-kubelet-client.crt
$ sudo cp /home/vagrant/PKI/k8s-master-01-key.pem /etc/kubernetes/pki/apiserver-kubelet-client.key
```


```console
$ sudo curl -s  --cacert /etc/kubernetes/pki/ca.crt --cert /etc/kubernetes/pki/apiserver-kubelet-client.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key -XGET 'https://192.168.56.201:6443/api?timeout=32s' |python3 -m json.tool
```

```json
{
    "kind": "APIVersions",
    "versions": [
        "v1"
    ],
    "serverAddressByClientCIDRs": [
        {
            "clientCIDR": "0.0.0.0/0",
            "serverAddress": "192.168.56.201:6443"
        }
    ]
}
```

#### `/api/v1` (APIResourceList)

This endpoint will return objects/resources in core group `v1`

```console
$ sudo curl -s  --cacert /etc/kubernetes/pki/ca.crt --cert /etc/kubernetes/pki/apiserver-kubelet-client.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key -XGET 'https://192.168.56.201:6443/api/v1?timeout=32s' |python3 -m json.tool
```

```json
{
    "kind": "APIResourceList",
    "groupVersion": "v1",
    "resources": [
        {
            "name": "bindings",
            "singularName": "",
            "namespaced": true,
            "kind": "Binding",
            "verbs": [
                "create"
            ]
        },
        {
            "name": "componentstatuses",
            "singularName": "",
            "namespaced": false,
            "kind": "ComponentStatus",
            "verbs": [
                "get",
                "list"
            ],
            "shortNames": [
                "cs"
            ]
        },
        {
            "name": "configmaps",
            "singularName": "",
            "namespaced": true,
            "kind": "ConfigMap",
            "verbs": [
                "create",
                "delete",
                "deletecollection",
                "get",
                "list",
                "patch",
                "update",
                "watch"
            ],
            "shortNames": [
                "cm"
            ]
        },
...
...
...
        {
    "name": "services/status",
    "singularName": "",
    "namespaced": true,
    "kind": "Service",
    "verbs": [
        "get",
        "patch",
        "update"
    ]
}
]
}


```

### Named Groups

#### `/apis` (APIGroupList)

This endpoint will return all named groups

```console
$ sudo curl -s  --cacert /etc/kubernetes/pki/ca.crt --cert /etc/kubernetes/pki/apiserver-kubelet-client.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key -XGET 'https://192.168.56.201:6443/apis?timeout=32s' |python3 -m json.tool
```

#### `/api/apps` (APIGroup)

```console
$ sudo curl -s  --cacert /etc/kubernetes/pki/ca.crt --cert /etc/kubernetes/pki/apiserver-kubelet-client.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key -XGET 'https://192.168.56.201:6443/apis/apps?timeout=32s' |python3 -m json.tool
```

```json
{
    "kind": "APIGroup",
    "apiVersion": "v1",
    "name": "apps",
    "versions": [
        {
            "groupVersion": "apps/v1",
            "version": "v1"
        },
        {
            "groupVersion": "apps/v1beta2",
            "version": "v1beta2"
        },
        {
            "groupVersion": "apps/v1beta1",
            "version": "v1beta1"
        }
    ],
    "preferredVersion": {
        "groupVersion": "apps/v1",
        "version": "v1"
    }
}
```
#### `/api/apps/v1` (APIResourceList)

Will return objects / resources under apps/v1
```console
$ sudo curl -s  --cacert /etc/kubernetes/pki/ca.crt --cert /etc/kubernetes/pki/apiserver-kubelet-client.crt --key /etc/kubernetes/pki/apiserver-kubelet-client.key -XGET 'https://192.168.56.201:6443/apis/apps/v1?timeout=32s' |python3 -m json.tool
```

```json
{
    "kind": "APIResourceList",
    "apiVersion": "v1",
    "groupVersion": "apps/v1",
    "resources": [
        {
            "name": "controllerrevisions",
            "singularName": "",
            "namespaced": true,
            "kind": "ControllerRevision",
            "verbs": [
                "create",
                "delete",
                "deletecollection",
                "get",
                "list",
                "patch",
                "update",
                "watch"
            ]
        },
        {
            "name": "daemonsets",
            "singularName": "",
            "namespaced": true,
            "kind": "DaemonSet",
            "verbs": [
                "create",
                "delete",
                "deletecollection",
                "get",
                "list",
                "patch",
                "update",
                "watch"
            ],
            "shortNames": [
                "ds"
            ],
            "categories": [
                "all"
            ]
        },
...
...
...
        {
            "name": "statefulsets/status",
            "singularName": "",
            "namespaced": true,
            "kind": "StatefulSet",
            "verbs": [
                "get",
                "patch",
                "update"
            ]
        }
    ]
}
```

### API versions

Different API versions imply different levels of stability and support

#### Alpha level:
- The version names contain alpha (e.g. v1alpha1).
- May be buggy. Enabling the feature may expose bugs. Disabled by default.
- Support for feature may be dropped at any time without notice.
- The API may change in incompatible ways in a later software release without notice.
- Recommended for use only in short-lived testing clusters, due to increased risk of bugs and lack of long-term support.

#### Beta level:
- The version names contain beta (e.g. v2beta3).
- Code is well tested. Enabling the feature is considered safe. Enabled by default.
- Support for the overall feature will not be dropped, though details may change.
- The schema and/or semantics of objects may change in incompatible ways in a subsequent beta or stable release. When this happens, k8s developers will provide instructions for migrating to the next version. This may require deleting, editing, and re-creating API objects. The editing process may require some thought. This may require downtime for applications that rely on the feature.
- Recommended for only non-business-critical uses because of potential for incompatible changes in subsequent releases. If you have multiple clusters which can be upgraded independently, you may be able to relax this restriction.
- Please do try our beta features and give feedback on them! Once they exit beta, it may not be practical for us to make more changes.

#### Stable level:
The version name is vX where X is an integer.
Stable versions of features will appear in released software for many subsequent versions

### List API version using `kubectl`

#### API Versions
```console
$ kubectl api-versions
admissionregistration.k8s.io/v1beta1
apiextensions.k8s.io/v1beta1
apiregistration.k8s.io/v1
apiregistration.k8s.io/v1beta1
apps/v1
apps/v1beta1
apps/v1beta2
authentication.k8s.io/v1
authentication.k8s.io/v1beta1
authorization.k8s.io/v1
authorization.k8s.io/v1beta1
autoscaling/v1
autoscaling/v2beta1
autoscaling/v2beta2
batch/v1
batch/v1beta1
certificates.k8s.io/v1beta1
coordination.k8s.io/v1beta1
crd.projectcalico.org/v1
events.k8s.io/v1beta1
extensions/v1beta1
networking.k8s.io/v1
policy/v1beta1
rbac.authorization.k8s.io/v1
rbac.authorization.k8s.io/v1beta1
scheduling.k8s.io/v1beta1
storage.k8s.io/v1
storage.k8s.io/v1beta1
v1
```

#### API resources

```console
$ kubectl api-resources
NAME                              SHORTNAMES   APIGROUP                       NAMESPACED   KIND
bindings                                                                      true         Binding
componentstatuses                 cs                                          false        ComponentStatus
configmaps                        cm                                          true         ConfigMap
endpoints                         ep                                          true         Endpoints
events                            ev                                          true         Event
limitranges                       limits                                      true         LimitRange
namespaces                        ns                                          false        Namespace
nodes                             no                                          false        Node
persistentvolumeclaims            pvc                                         true         PersistentVolumeClaim
persistentvolumes                 pv                                          false        PersistentVolume
pods                              po                                          true         Pod
podtemplates                                                                  true         PodTemplate
replicationcontrollers            rc                                          true         ReplicationController
resourcequotas                    quota                                       true         ResourceQuota
secrets                                                                       true         Secret
serviceaccounts                   sa                                          true         ServiceAccount
services                          svc                                         true         Service
mutatingwebhookconfigurations                  admissionregistration.k8s.io   false        MutatingWebhookConfiguration
validatingwebhookconfigurations                admissionregistration.k8s.io   false        ValidatingWebhookConfiguration
customresourcedefinitions         crd,crds     apiextensions.k8s.io           false        CustomResourceDefinition
apiservices                                    apiregistration.k8s.io         false        APIService
controllerrevisions                            apps                           true         ControllerRevision
daemonsets                        ds           apps                           true         DaemonSet
deployments                       deploy       apps                           true         Deployment
replicasets                       rs           apps                           true         ReplicaSet
statefulsets                      sts          apps                           true         StatefulSet
tokenreviews                                   authentication.k8s.io          false        TokenReview
localsubjectaccessreviews                      authorization.k8s.io           true         LocalSubjectAccessReview
selfsubjectaccessreviews                       authorization.k8s.io           false        SelfSubjectAccessReview
selfsubjectrulesreviews                        authorization.k8s.io           false        SelfSubjectRulesReview
subjectaccessreviews                           authorization.k8s.io           false        SubjectAccessReview
horizontalpodautoscalers          hpa          autoscaling                    true         HorizontalPodAutoscaler
cronjobs                          cj           batch                          true         CronJob
jobs                                           batch                          true         Job
certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest
leases                                         coordination.k8s.io            true         Lease
bgpconfigurations                              crd.projectcalico.org          false        BGPConfiguration
bgppeers                                       crd.projectcalico.org          false        BGPPeer
clusterinformations                            crd.projectcalico.org          false        ClusterInformation
felixconfigurations                            crd.projectcalico.org          false        FelixConfiguration
globalnetworkpolicies                          crd.projectcalico.org          false        GlobalNetworkPolicy
globalnetworksets                              crd.projectcalico.org          false        GlobalNetworkSet
hostendpoints                                  crd.projectcalico.org          false        HostEndpoint
ippools                                        crd.projectcalico.org          false        IPPool
networkpolicies                                crd.projectcalico.org          true         NetworkPolicy
events                            ev           events.k8s.io                  true         Event
daemonsets                        ds           extensions                     true         DaemonSet
deployments                       deploy       extensions                     true         Deployment
ingresses                         ing          extensions                     true         Ingress
networkpolicies                   netpol       extensions                     true         NetworkPolicy
podsecuritypolicies               psp          extensions                     false        PodSecurityPolicy
replicasets                       rs           extensions                     true         ReplicaSet
networkpolicies                   netpol       networking.k8s.io              true         NetworkPolicy
poddisruptionbudgets              pdb          policy                         true         PodDisruptionBudget
podsecuritypolicies               psp          policy                         false        PodSecurityPolicy
clusterrolebindings                            rbac.authorization.k8s.io      false        ClusterRoleBinding
clusterroles                                   rbac.authorization.k8s.io      false        ClusterRole
rolebindings                                   rbac.authorization.k8s.io      true         RoleBinding
roles                                          rbac.authorization.k8s.io      true         Role
priorityclasses                   pc           scheduling.k8s.io              false        PriorityClass
storageclasses                    sc           storage.k8s.io                 false        StorageClass
volumeattachments                              storage.k8s.io                 false        VolumeAttachment
```
