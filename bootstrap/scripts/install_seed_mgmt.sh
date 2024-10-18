#!/bin/bash
#
# source VERSION
export KIND_VERSION="${KIND_VERSION:-v0.24.0}"
export KUBECTL_VERSION="${KUBECTL_VERSION:-v1.29.8}"
#export KUBECTL_VERSION="$(curl -Lfs $KUBECTL_RELEASE_VERSION/stable.txt)"
export KUBERNETES_VERSION=${KUBERNETES_VERSION:-v1.29.8}
export HELM_VERSION="${HELM_VERSION:-v3.16.1}"
export HELMFILE_VERSION="${HELMFILE_VERSION:-0.168.0}"
export MKCERT_VERSION="${MKCERT_VERSION:-v1.4.4}"
export AGE_VERSION="${AGE_VERSION:-v1.2.0}"
export SOPS_VERSION="${SOPS_VERSION:-v3.8.1}"
export CLUSTERCTL_VERSION=${CLUSTERCTL_VERSION:-v1.8.4}
export YQ_VERSION=${YQ_VERSION:-v4.44.3}

# install some tools (kind, kubectl, helm...)
curl -L https://raw.githubusercontent.com/numerique-gouv/dk8s/main/scripts/install-prereq.sh | bash

# install clusterctl
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/${CLUSTERCTL_VERSION}/clusterctl-linux-amd64 -o clusterctl
chmod +x clusterctl
sudo mv clusterctl /usr/local/bin/clusterctl

# install yq
curl -LO https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64.tar.gz
tar -zxvf yq_linux_amd64.tar.gz  ./yq_linux_amd64
rm -rf yq_linux_amd64.tar.gz
chmod +x yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq

# create cluster
kind create cluster --name mgmt --image kindest/node:${KUBERNETES_VERSION} --config - <<EOF
---
#
# specifications to emulate simple ready to use cluster
# - ingress-nginx on control plane, labeled ingress-ready
# - expose application service to one ingress-nginx on control-plane, locally exposed on ports 80/443
#
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        # by default, ingress-nginx on kind use ingress-ready=true
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
EOF

# wait kind ready
kubectl wait -n kube-system deployment coredns --for=condition=Available --timeout=300s
