#!/bin/bash
#
# configure capo and caaph to use http_proxy
# import configmap http proxy config
#
if [ ! -z "${http_proxy}" ]; then
http_proxy="${http_proxy:? error}"
https_proxy="${https_proxy:? error}"
no_proxy=".svc,.svc.cluster,.svc.cluster.local,127.0.0.0/8,10.96.0.0/12,172.16.0.0/16,192.168.0.0/16"

for controller in capo caaph ; do
echo "# create configmap proxy-config $controller"
cat <<EOF_CONFIG | kubectl -n $controller-system apply -f -
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
# configure capo/caaph http_proxy
#
echo "# set env proxy-config $controller"
kubectl set env deployment/$controller-controller-manager --namespace=$controller-system --from=configmap/proxy-config --containers='*'
done
fi

