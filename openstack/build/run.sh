#!/bin/bash
#
# run.sh [kube_version] [extra-docker-args]
#    ex: to add explicit ip of openstack api endpoint
#    run.sh 127 "--add-host identity.openstack.local:10.1.1.1"
#

kube_version="${1:-}"
docker_args=" $2 "
IMAGE_BUILDER_VERSION="${IMAGE_BUILDER_VERSION:-v0.1.26}"

if [[ $# -gt 0 &&  "$kube_version" != "" ]]; then
  docker_args=" $docker_args  -v ./extra_vars_kube_${kube_version}.json:/data/extra_vars_kube_${kube_version}.json "
  EXTRA_PACKER_VAR_FILES="/data/extra_vars_kube_${kube_version}.json"
fi

# add custom ansible roles
docker_args=" $docker_args -v ./ansible/roles/custom:/home/imagebuilder/ansible/roles/custom "
docker_args=" $docker_args -v ./ansible/roles/goss:/home/imagebuilder/ansible/roles/goss "

docker run -it --rm --net=host \
  $docker_args \
	-v ./packer.json:/data/packer.json \
	--env PACKER_VAR_FILES="/data/packer.json $EXTRA_PACKER_VAR_FILES" \
	--env-file ./packer.openstack.rc \
        --entrypoint /bin/bash \
	registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:${IMAGE_BUILDER_VERSION}
