#!/bin/bash
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"
#
# install helm metallb with overrided values
# For demo, external LB is provsionned in openstack outside cluster api
#

## preallocate LB port and fixed api in openstack subnet before applying config
METALLB_FIXED_IP=${METALLB_FIXED_IP:-192.168.101.11/32}
METALLB_NAMESPACE=${METALLB_NAMESPACE:-metallb}

helm --kubeconfig=${CLUSTER_NAME}.kubeconfig upgrade --install metallb metallb --repo https://metallb.github.io/metallb --namespace ${METALLB_NAMESPACE} --create-namespace -f sample-demo/metallb-values.yaml  --wait-for-jobs  --wait

kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig wait crds/l2advertisements.metallb.io  --for condition=established --timeout=60s
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig wait crds/ipaddresspools.metallb.io  --for condition=established --timeout=60s

cat <<EOF_CONFIG | kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig -n ${METALLB_NAMESPACE} apply -f -
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: ${METALLB_NAMESPACE}
spec:
  addresses:
  - ${METALLB_FIXED_IP} ## preallocate LB port and fixed api in openstack subnet before applying config
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: lb
  namespace: ${METALLB_NAMESPACE}
spec:
  ipAddressPools:
  - first-pool
EOF_CONFIG
