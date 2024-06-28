#!/bin/bash
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubeconfig_dir="$(dirname $0)"
KUBECONFIG="$HOME/.kube/${CLUSTER_NAME}.kubeconfig"

if [ ! -f "${KUBECONFIG}" ] ; then
  echo "${KUBECONFIG} not found"
  exit 1
fi

kubectl_args="--kubeconfig=${KUBECONFIG}"

CILIUM_VERSION=1.15.5

helm ${kubectl_args} upgrade --install cilium cilium \
  --repo https://helm.cilium.io/ \
  --version ${CILIUM_VERSION}  \
  -f sample-demo/cni-cilium-values.yaml \
  --namespace kube-system \
  --create-namespace
