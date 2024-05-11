#!/bin/bash
#
# install dummy hello for demo
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

HELLO_NAMESPACE=${HELLO_NAMESPACE:-hello}
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig  create namespace ${HELLO_NAMESPACE}
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig  apply -f sample-demo/hello.yaml -n ${HELLO_NAMESPACE}
