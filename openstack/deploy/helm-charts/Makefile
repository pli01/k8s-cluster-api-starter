HELM_VALUE = ""
CLUSTER_NAME = ""

index: package-capi-cluster \
       package-capi-cluster-addons \
       index-repo
package-capi-cluster:
	helm package capi-cluster -d repo/
package-capi-cluster-addons:
	helm package capi-cluster-addons -d repo/
index-repo:
	helm repo index repo/

SHELL := /bin/bash
check-template:
	[[ -n "${HELM_VALUE}" && -n "${CLUSTER_NAME}" ]] || exit 1
template-capi-cluster: check-template
	helm template -f ${HELM_VALUE} ${CLUSTER_NAME} capi-cluster
template-capi-cluster-addons: check-template
	helm template -f ${HELM_VALUE} ${CLUSTER_NAME} capi-cluster-addons
