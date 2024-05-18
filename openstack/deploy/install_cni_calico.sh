#!/bin/bash
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubeconfig_dir="$(dirname $0)"
KUBECONFIG="$kubeconfig_dir/${CLUSTER_NAME}.kubeconfig"

if [ ! -f "${KUBECONFIG}" ] ; then
  echo "${KUBECONFIG} not found"
  exit 1
fi

kubectl_args="--kubeconfig=${KUBECONFIG}"

#CALICO_VERSION=v3.28.0
CALICO_VERSION=v3.27.3

helm ${kubectl_args} upgrade --install calico tigera-operator \
  --repo https://docs.tigera.io/calico/charts \
  --version ${CALICO_VERSION}  \
  -f sample-demo/cni-calico-values.yaml \
  --namespace kube-system \
  --create-namespace --wait-for-jobs --wait
