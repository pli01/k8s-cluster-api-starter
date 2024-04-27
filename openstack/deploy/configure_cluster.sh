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
clusterctl get kubeconfig ${CLUSTER_NAME}  > ${CLUSTER_NAME}.kubeconfig
#
# calico
#   - disable Reports anonymous Calico version number and cluster size to projectcalico.org
#   - use pod cidr in CALICO_IPV4POOL_CIDR
#
curl -sL https://raw.githubusercontent.com/projectcalico/calico/release-v3.27/manifests/calico.yaml | \
  yq e '[{"name": "CALICO_IPV4POOL_CIDR", "value": "172.16.0.0/16"},{"name": "FELIX_USAGEREPORTINGENABLED", "value": "false"}] as $env |
	select(.kind == "DaemonSet" and .metadata.name == "calico-node") .spec.template.spec.containers[0] |= .env += $env' | \
  kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig apply -f -

#
# import secret cloud.conf
#
if [ ! -f cloud.conf ] ;then
	echo "must have cloud.conf"
fi
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig  create secret -n kube-system generic cloud-config --from-file=cloud.conf

#
# import configmap http proxy config
#
if [ ! -z "${http_proxy}" ]; then
http_proxy="${http_proxy:? error}"
https_proxy="${https_proxy:? error}"
no_proxy=".svc,.svc.cluster,.svc.cluster.local,127.0.0.0/8,10.96.0.0/12,172.16.0.0/16,192.168.0.0/16"

cat <<EOF_CONFIG | kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig -n kube-system apply -f -
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: proxy-config
data:
  HTTP_PROXY: $http_proxy
  HTTPS_PROXY: $https_proxy
  NO_PROXY: $no_proxy
  http_proxy: $http_proxy
  https_proxy: $https_proxy
  no_proxy: $no_proxy
EOF_CONFIG
fi
#
# openstack ccm
#
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/release-1.29/manifests/controller-manager/cloud-controller-manager-roles.yaml
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/release-1.29/manifests/controller-manager/cloud-controller-manager-role-bindings.yaml
#
# patch occm to use http_proxy (if openstack API is not directly accessible, in some configurations)
#
if [ ! -z "${http_proxy}" ]; then
  curl -sSL https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/release-1.29/manifests/controller-manager/openstack-cloud-controller-manager-ds.yaml | \
    yq e '[ { "configMapRef": {"name": "proxy-config" } } ] as $env |
	select(.kind == "DaemonSet" and .metadata.name == "openstack-cloud-controller-manager") .spec.template.spec.containers[0] |= .envFrom += $env' | \
    kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig apply -f -
else
    kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-openstack/release-1.29/manifests/controller-manager/openstack-cloud-controller-manager-ds.yaml
fi
