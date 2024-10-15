# Deploy cluster-api on cloud

## Openstack Cloud Cluster templates

cluster-templates are available

The following workload cluster infrastructures have been tested in openstack cloud

- managed subnet, without LBaaS, without ctrlplane HA

![managed subnet, without LBaaS, without API HA](images/cluster-api-cluster-managed-subnet.drawio.png)

- existing network, without LBaaS, HA ctrlplane with kube-vip

![existing subnet, without LBaaS, with API HA with kube-vip](images/cluster-api-cluster-kube-vip.drawio.png)

- existing subnet, with cilium LB for workload traffic, with API HA with kube-vip

![existing subnet, with LB cilium for workload traffic, with API HA with kube-vip](images/cluster-api-cluster-kube-vip-cilium.drawio.png)

- existing subnet, with calico + LB metallb for workload traffic, with API HA with kube-vip

![existing subnet, with LB metallb for workload traffic, with API HA with kube-vip](images/cluster-api-cluster-kube-vip-metallb.drawio.png)


## Outscale Cloud Cluster templates

![Sample cluster-api on outscale](https://blog.outscale.com/wp-content/uploads/2023/05/operator_OUTSCALE-1.png)

https://blog.outscale.com/en/developing-a-cluster-api-provider-at-outscale/
