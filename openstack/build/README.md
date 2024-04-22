# cluster node-image-builder (openstack)

How to build image kubernetes images on openstack cloud to run cluster-api

reference:
- https://image-builder.sigs.k8s.io/capi/container-image
- https://image-builder.sigs.k8s.io/capi/providers/openstack-remote
- https://developer.hashicorp.com/packer/integrations/hashicorp/openstack/latest/components/builder/openstack

The following steps must run on an instance with:
  - openstack API access (https)
  - internet access (http_proxy)
  - docker installed
  - network access and ssh access to the builded instance

# steps
The easiest is to pull image-builder with all included tools (packer,ansible,...)

```
docker pull registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:v0.1.25

# test it
docker run -it --entrypoint /bin/bash  --rm --net=host registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:v0.1.25 
```

```
# to debug (not necessary to build image)
umask 0022
git clone https://github.com/kubernetes-sigs/image-builder.git
```

# run a shell
```
# run.sh
run.sh : contains the docker command line and argument to run image builder with all files included
in the container, run, the following command
make build-openstack-ubuntu-2204
```
# build cloud images
```
# build.sh
build.sh: start the build of kubernetes image based on ubuntu OS
  - you can specify kubernetes version to install (127,128,129,130) according to extra_args_kube_${kube_version}.json
  - you can add extra docker args

# in this example, we build kubernetes 1.27 version and add an explicit hosts entry in container docker to openstack api

build.sh  127 "--add-host identity.openstack.local:10.1.1.1

.... Wait 10/15mn and list the fresh openstack image ...

openstack image show ubuntu-2204-kube-v1.26.7
```

# when done
set min-disk size
```
openstack image set  ubuntu-2204-kube-v1.26.7  --min-disk 10

Verify:
openstack image list
openstack image show ubuntu-2204-kube-v1.26.7
```
