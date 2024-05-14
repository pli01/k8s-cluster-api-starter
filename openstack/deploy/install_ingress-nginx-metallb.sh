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

#
# install helm ingress-nginx with overrided values for metallb
# For demo, external LB is provsionned in openstack outside cluster api
#   - ingress-nginx is configured in LoadBalancer mode with metallb class
#   - trafic from LB is routed to metallb Lb then to ingress worker node hosting ingress-nginx
#
helm ${kubectl_args} upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f sample-demo/ingress-nginx-metallb-values.yaml  --wait-for-jobs  --wait

