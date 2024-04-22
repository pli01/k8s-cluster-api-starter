# k8s-cluster-api-starter

Useful steps, configuration and scripts to build kubernetes images and deploy cluster-api clusters on openstack or outscale

For more details see the directories

Tested on:
- openstack

Todo:
- outscale

## Documentation reference:

Image builder:
- https://image-builder.sigs.k8s.io/capi/container-image
- https://image-builder.sigs.k8s.io/capi/providers/openstack-remote
- https://image-builder.sigs.k8s.io/capi/providers/3dsoutscale
- https://github.com/kubernetes-sigs/image-builder

cluster-api:
- https://cluster-api.sigs.k8s.io/

cluster-api provider:
- Openstack:
  - https://cluster-api-openstack.sigs.k8s.io/
  - https://github.com/kubernetes-sigs/cluster-api-provider-openstack
- Outscale:
  - https://cluster-api-outscale.oos-website.eu-west-2.outscale.com/
  - https://github.com/outscale/cluster-api-provider-outscale
