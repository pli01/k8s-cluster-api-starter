#!/bin/bash
#
# configure capo to use http_proxy
# import configmap http proxy config
#
if [ ! -z "${http_proxy}" ]; then
http_proxy="${http_proxy:? error}"
https_proxy="${https_proxy:? error}"
no_proxy=".svc,.svc.cluster,.svc.cluster.local,127.0.0.0/8,10.96.0.0/12,172.16.0.0/16,192.168.0.0/16"

cat <<EOF_CONFIG | kubectl -n capo-system apply -f -
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

#
# configure capo http_proxy
#
kubectl set env deployment/capo-controller-manager --namespace=capo-system --from=configmap/proxy-config --containers='*'
fi

