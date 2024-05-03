#!/bin/bash
#
# install dummy whoami for demo
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig  apply -f sample-demo/whoami.yaml
