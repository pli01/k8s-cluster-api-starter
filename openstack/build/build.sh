#!/bin/bash
#
# build openstack ubuntu 2204 kubernetes
#
# build.sh [extra-docker-args]
#    ex: to add explicit ip of openstack api endpoint
#    build.sh	"--add-host identity.openstack.local:10.1.1.1"
#
docker_args=" $1 "

docker run -it --rm --net=host \
  $docker_args \
	--env-file ./packer.openstack.rc \
	--env PACKER_VAR_FILES=/data/packer.json  \
	-v ./packer.json:/data/packer.json \
	-v ./image-builder/images/capi/packer:/home/imagebuilder/packer \
	registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:v0.1.25 \
  build-openstack-ubuntu-2204
