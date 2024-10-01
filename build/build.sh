#!/bin/bash
#
# build provider ubuntu 2204 kubernetes
#
# build.sh [provider] [kube_version] [extra-docker-args]
#    ex: to add explicit ip of provider api endpoint
#    build.sh	127 "--add-host identity.$PACKER_PROVIDER.local:10.1.1.1"
#
#

PACKER_PROVIDER="${1:? provider needed (openstack,outscale)}"
kube_version="${2:-}"
docker_args=" $3 "
IMAGE_BUILDER_VERSION="${IMAGE_BUILDER_VERSION:-v0.1.36}"

packer_provider_json="./config/packer.$PACKER_PROVIDER.json"
packer_provider_rc="./config/packer.$PACKER_PROVIDER.rc"

if [[ ! -f "$packer_provider_json" && -f "$packer_provider_rc"  ]]; then
	echo "Config file $packer_provider_json or $ packer_provider_rc not found"
	exit 1
fi

export target=$PACKER_PROVIDER
case $PACKER_PROVIDER in
  outscale) target=osc ;;
esac

if [[ $# -gt 0 &&  "$kube_version" != "" ]]; then
  docker_args=" $docker_args  -v ./extra_vars/kube_${kube_version}.json:/data/extra_vars_kube_${kube_version}.json "
  EXTRA_PACKER_VAR_FILES="/data/extra_vars_kube_${kube_version}.json"
fi

# add custom ansible roles
#docker_args=" $docker_args --env DEBUG=1 "
docker_args=" $docker_args -v ./ansible/roles/custom:/home/imagebuilder/ansible/roles/custom "
docker_args=" $docker_args -v ./ansible/roles/goss:/home/imagebuilder/ansible/roles/goss "
docker_args=" $docker_args -v ./ansible.cfg:/home/imagebuilder/ansible.cfg "
docker_args=" $docker_args -v ./packer/$PACKER_PROVIDER/:/home/imagebuilder/packer/$PACKER_PROVIDER/ "

docker run --name "image-builder" -it --rm --net=host \
  $docker_args \
	-v ${packer_provider_json}:/data/packer.json \
	--env PACKER_VAR_FILES="/data/packer.json $EXTRA_PACKER_VAR_FILES" \
	--env-file ${packer_provider_rc} \
	registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:$IMAGE_BUILDER_VERSION \
  build-$target-ubuntu-2204
