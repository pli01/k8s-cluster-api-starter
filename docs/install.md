# Deploy cluster-api on cloud

## deploy cluster-api on openstack

The following steps must run on an instance with:
  - install prereq: yq, env.rc
  - install clusterctl
  - install kind, kubectl, helm: use github.com/numerique-gouv/dk8s install prereq scripts
  - acces to openstack API
  - openstack credentials (`OS_*`)
  - internet acces (`http_proxy`)
  - dns server: to resolve openstack API if needed (ex: unbound)


In this example, we use predefined resources
 - private openstack cloud
 - internet access through internal `http_proxy`
 - openstack API access through `http_proxy`
 - existing instances: bastion, `http_proxy` and dns resolver
 - existing router, network, subnet
 - cluster mgmt is installed on bastion instance
 - workload cluster will be deployed in existing subnet

We use following components:
On Mgmt Cluster:
- cluster-api
- cluster-api-provider-openstack
- cluster-api-addons-provider-helm
- capi2argo cluster operator
- argocd + ingress-nginx (install your own to postconfigure workload cluster)

On workload cluster:
- kube-vip (on ctrl plane)
- cilium (on nodes)
-   or calico and  metallb
- cert-manager
- ingress-nginx

# Create workload configuration

Different ways to create a workload cluster:
  - with clusterctl template and kubectl apply
  - with helm charts

## with clusterctl template and kubectl apply

- generate cluster config from template (without lb)

```
clusterctl generate cluster capi-quickstart --flavor without-lb --kubernetes-version v1.26.7 --control-plane-machine-count=1 > capi-quickstart.yaml
```

- customize the template to feet cluster/node configuration

In this example:
  - disable bastion and floating ip for api
  - use existing network/subnet/router/ip
  - fix private API ip adress
  - security-group
  - root volume, etc...

## with helm chart 

See helm-charts directory , and customize values files

# create workload cluster
- with kubectl apply
- with helm chart

## with kubectl apply

Create the workload cluster, from the previous template (ex: capi-quickstart.yaml)

To be ready, the workload cluster must have a CNI installed and the openstack controller manager must access the openstack API (with http_proxy if needed)

```
kubectl apply -f capi-quickstart.yaml

# configure CNI and openstack controller manager to use http_proxy
bash configure_cluster.sh capi-quickstart

# follow the deployment of the cluster
kubectl get machine -A

# verify with openstack api
openstack server list

```
