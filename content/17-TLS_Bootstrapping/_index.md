
Create a Token

$ head -c 16 /dev/urandom | od -An -t x | tr -d ' '
12c12e7eb3a9c3f9255bb74529c6768e

$ echo 12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,\"system:bootstrappers\" |sudo tee -a /etc/kubernetes/config/bootstrap-token.conf
12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,"system:bootstrappers"

Create a token auth file

$ cat /etc/kubernetes/config/bootstrap-token.conf
12c12e7eb3a9c3f9255bb74529c6768e,kubelet-bootstrap,10001,"system:bootstrappers"



--enable-bootstrap-token-auth=true \
--token-auth-file=/etc/kubernetes/config/bootstrap-token.conf \

Add RBAC for Node TLS bootstrapping

cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: create-csrs-for-bootstrapping
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:node-bootstrapper
  apiGroup: rbac.authorization.k8s.io
EOF


cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-csrs-for-group
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:nodeclient
  apiGroup: rbac.authorization.k8s.io
EOF

cat <<EOF | kubectl create -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-renewals-for-nodes
subjects:
- kind: Group
  name: system:nodes
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
  apiGroup: rbac.authorization.k8s.io
EOF


Create a bootstrap-kubeconfig which can be used by kubelet


TOKEN=$(awk -F "," '{print $1}' /etc/kubernetes/config/bootstrap-token.conf)

KUBERNETES_PUBLIC_ADDRESS=$(grep master /etc/hosts |awk '{print $1}')

kubectl config --kubeconfig=bootstrap-kubeconfig set-cluster bootstrap --embed-certs=true --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 --certificate-authority=ca.pem

kubectl config --kubeconfig=bootstrap-kubeconfig set-credentials kubelet-bootstrap --token=${TOKEN}

kubectl config --kubeconfig=bootstrap-kubeconfig set-context bootstrap --user=kubelet-bootstrap --cluster=bootstrap

kubectl config --kubeconfig=bootstrap-kubeconfig use-context bootstrap

=====================

On Worker node

sudo swapoff /dev/dm-1
sudo systemctl start docker

sudo mkdir -p \
  /var/lib/kubelet \

chmod +x kubectl kube-proxy kubelet
sudo mv kubectl kube-proxy kubelet /usr/local/bin/

sudo cp bootstrap-kubeconfig /var/lib/kubelet/

sudo kubelet --bootstrap-kubeconfig="/var/lib/kubelet/bootstrap-kubeconfig" --kubeconfig="/var/lib/kubelet/kubeconfig"
