#!/bin/bash
set -e

CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubeconfig_dir="$(dirname $0)"
KUBECONFIG="$HOME/.kube/${CLUSTER_NAME}.kubeconfig"

if [ ! -f "${KUBECONFIG}" ] ; then
  echo "${KUBECONFIG} not found"
  exit 1
fi

kubectl_args="--kubeconfig=${KUBECONFIG}"

if [ -f ccm/secrets.yaml ] ; then
  kubectl $kubectl_args apply -f ccm/secrets.yaml
else
  kubectl $kubectl_args get -n kube-system secret osc-secret || exit 1
fi

( cd ccm
  # get last helm
  if [ ! -d cloud-provider-osc-OSC-MIGRATION/deploy/k8s-osc-ccm ] ;then
    curl -LO https://github.com/outscale/cloud-provider-osc/archive/refs/heads/OSC-MIGRATION.tar.gz
    tar -zxvf OSC-MIGRATION.tar.gz
  fi
  
  helm ${kubectl_args} upgrade --install  \
    k8s-osc-ccm cloud-provider-osc-OSC-MIGRATION/deploy/k8s-osc-ccm \
    -f osc-ccm-values.yaml \
    --namespace kube-system \
    --create-namespace \
    --wait --wait-for-jobs
)
