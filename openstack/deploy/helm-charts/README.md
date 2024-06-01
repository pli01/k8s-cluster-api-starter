# cluster-api helm chart

Helm charts to install Cluster API manifests.

Currently the chart install:
- target cluster for Openstack
It is planned to include support for other cluster API providers.
- In addition, it is possible to install in each clusters, additional components in the form
 of helm charts such as CNI, CCM, Ingress, and

Providers:
  - openstack

Helmchartproxy addons:
  - ccm: openstack
  - cni: (choose on)
    - calico
    - cilium (include LB)
  - metallb (with calico): LB for ingress
  - ingress-nginx
  - cert-manager
  - local-path-provisioner (helm index from rancher)


## directory structures

```
capi-cluster
  - charts/openstack
  - ClusterResourceSet is used to deploy calico, cilium or secrets config
capi-cluster-addons: helm charts for all addons (CNI,CCM...)
repo: helm repo index
```

## Use it

```
# create config for your cluster for example: environments/c1-dev.yaml
# Adapt and modify to your needs (image, network, replica, credentials...)

export CLUSTER_NAME=c1-dev
cat environment/c1-demo.yaml.sample > environments/${CLUSTER_NAME}.yaml
cat environment/cluster-addons.yaml.sample > environments/cluster-addons.yaml

# install helm addons
helm upgrade --install -f environments/cluster-addons.yaml helm-addons ./capi-cluster-addons  --wait

# install workload cluster
helm upgrade --install -f environments/${CLUSTER_NAME}.yaml ${CLUSTER_NAME} ./capi-cluster  --wait

## Cluster is creating, check events !!

# get cluster kubeconfig
clusterctl get kubeconfig ${CLUSTER_NAME} > ${CLUSTER_NAME}.kubeconfig

# get pod
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig get pod -A

# uninstall cluster
helm uninstall ${CLUSTER_NAME} --wait
```


## Tips and tricks

```
# On mgmt cluster
kubectl get cluster -A

# see clusterresourceset
kubectl get ClusterResourceSet -A
kubectl get configmap -A
kubectl get secrets -A

# On workload cluster, verify metallb config is deployed
kubectl --kubeconfig=${CLUSTER_NAME}.kubeconfig get L2Advertisement,ipaddresspool -A
```
