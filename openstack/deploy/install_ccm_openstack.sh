#!/bin/bash
#
# This script post configure a workload cluster after deploying a workload cluster in mgmt cluster
#  - configure CNI calico
#  - configure Openstack CCM (cloud.conf, http_proxy)
# After running this script, all machines on the workload cluster are ready to used
#
# get kubeconfig
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"

kubeconfig_dir="$(dirname $0)"
KUBECONFIG="$kubeconfig_dir/${CLUSTER_NAME}.kubeconfig"

export kubectl_args="--kubeconfig=${KUBECONFIG}"

if [ ! -f cloud.conf ] ;then
  echo "must have cloud.conf"
fi
kubectl ${kubectl_args}  create secret -n kube-system generic cloud-config --from-file=cloud.conf

#
# import configmap http proxy config
#
if [ ! -z "${http_proxy}" ]; then
  http_proxy="${http_proxy:? error}"
  https_proxy="${https_proxy:? error}"
  no_proxy=".svc,.svc.cluster,.svc.cluster.local,127.0.0.0/8,10.96.0.0/12,172.16.0.0/16,192.168.0.0/16"
fi
#
# openstack ccm
#
CLOUD_PROVIDER_OPENSTACK_VERSION=2.30.1

helm ${kubectl_args} upgrade --install openstack-ccm openstack-cloud-controller-manager \
  --repo https://kubernetes.github.io/cloud-provider-openstack  \
  --version ${CLOUD_PROVIDER_OPENSTACK_VERSION}  \
  -f sample-demo/ccm-openstack-values.yaml \
  --namespace kube-system \
  --create-namespace --wait-for-jobs --wait \
  --set-json 'extraEnv=[{"name":"http_proxy","value":"'$http_proxy'"},{"name":"https_proxy","value":"'$https_proxy'"},{"name":"no_proxy","value":"'$no_proxy'"}]'
