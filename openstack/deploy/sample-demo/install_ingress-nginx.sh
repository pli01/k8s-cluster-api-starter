#!/bin/bash
#
CLUSTER_NAME="${1:? argument not defined. run ./configure_cluster my-cluster-name }"
#
# install helm ingress-nginx with overrided values
# For demo, external LB is provsionned in openstack outside cluster api
#   - ingress-nginx is configured in NodePort mode (not LoadBalancer)
#   - trafic from LB is routed to ingress worker node hosting ingress-nginx
#
helm --kubeconfig=${CLUSTER_NAME}.kubeconfig upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f ingress-nginx-values.yaml 

