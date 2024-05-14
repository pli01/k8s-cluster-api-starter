#!/bin/bash
#
# install dummy whoami for demo
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubeconfig_dir="$(dirname $0)"
KUBECONFIG="$kubeconfig_dir/${CLUSTER_NAME}.kubeconfig"

if [ ! -f "${KUBECONFIG}" ] ; then
  echo "${KUBECONFIG} not found"
  exit 1
fi

kubectl_args="--kubeconfig=${KUBECONFIG}"

kubectl ${kubectl_args} apply -f sample-demo/whoami.yaml
