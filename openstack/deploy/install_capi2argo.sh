#!/bin/bash
#
# install helm chart capi2argo
#
release=capi2argo
chart=capi2argo-cluster-operator
chart_url=https://dntosas.github.io/capi2argo-cluster-operator/
namespace=kube-system

values=sample-demo/capi2argo-values.yaml
helm_args=""
if [ -f "$values" ] ;then
  helm_args=" -f $values "
fi

helm ${kubectl_args} upgrade --install \
  $release $chart \
  --repo $chart_url \
  --namespace $namespace \
  --create-namespace \
  --wait-for-jobs  --wait
  ${helm_args} \
