#!/bin/bash
#
# install some tools (kind, kubectl...)
# source VERSION
KIND_VERSION="${KIND_VERSION:-v0.24.0}"
KUBECTL_VERSION="${KUBECTL_VERSION:-v1.29.9}"
KUBECTL_VERSION="$(curl -Lfs $KUBECTL_RELEASE_VERSION/stable.txt)"
HELM_VERSION="${HELM_VERSION:-v3.16.1}"
HELMFILE_VERSION="${HELMFILE_VERSION:-0.168.0}"
MKCERT_VERSION="${MKCERT_VERSION:-v1.4.4}"
AGE_VERSION="${AGE_VERSION:-v1.2.0}"
SOPS_VERSION="${SOPS_VERSION:-v3.8.1}"

curl -L https://raw.githubusercontent.com/numerique-gouv/dk8s/main/scripts/install-prereq.sh | bash

# install clusterctl
CLUSTERCTL_VERSION=v1.8.3
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/${CLUSTERCTL_VERSION}/clusterctl-linux-amd64 -o clusterctl
chmod +x clusterctl
sudo mv clusterctl /usr/local/bin/clusterctl

# install yq
YQ_VERSION=v4.44.3
curl -LO https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64.tar.gz
tar -zxvf yq_linux_amd64.tar.gz  ./yq_linux_amd64
rm -rf yq_linux_amd64.tar.gz
chmod +x yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq

# create cluster
kind create cluster --name mgmt --config kind-cluster.yaml

# wait kind ready
kubectl wait -n kube-system deployment coredns --for=condition=Available --timeout=300s

export CLUSTER_TOPOLOGY=true
clusterctl init --infrastructure openstack --addon helm

# wait cluster-api ready
kubectl wait -n cert-manager deployment cert-manager --for=condition=Available --timeout=300s
kubectl wait -n capi-kubeadm-bootstrap-system deployment capi-kubeadm-bootstrap-controller-manager --for=condition=Available --timeout=300s
kubectl wait -n capi-kubeadm-control-plane-system deployment capi-kubeadm-control-plane-controller-manager --for=condition=Available --timeout=300s
kubectl wait -n capi-system deployment capi-controller-manager --for=condition=Available --timeout=300s
kubectl wait -n capo-system deployment capo-controller-manager --for=condition=Available --timeout=300s
kubectl wait -n caaph-system deployment caaph-controller-manager --for=condition=Available --timeout=300s

# configure http proxy in capo and caaph
bash configure_capo.sh

# install capi2argo operator
bash install_capi2argo.sh
