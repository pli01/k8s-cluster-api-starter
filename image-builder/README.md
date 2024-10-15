# cluster node-image-builder (openstack)

How to build image kubernetes images with packer/ansible on openstack cloud to run cluster-api

reference:
- https://image-builder.sigs.k8s.io/capi/container-image
- https://image-builder.sigs.k8s.io/capi/providers/openstack-remote
- https://developer.hashicorp.com/packer/integrations/hashicorp/openstack/latest/components/builder/openstack

The following steps must run on an instance with:
  - openstack API access (https and credentials)
  - internet access (http_proxy)
  - docker installed
  - network access and ssh access to the builded instance

# Quick steps
The easiest way to build kubernetes image is:
- pull image-builder docker image with all included tools (packer,ansible,...)
- prepare config files for your environment
- build target OS image
- use the new image in cluster-api workload config file

Quick steps is:
- prepare and copy packer.PROVIDER.json and packer.PROVIDER.rc into config/ directory
- build target image with `build.sh $KUBERNETES_VERSION` (image os is based on ubuntu2204)
- image is uploaded in image registry (glance in openstack): ubuntu-2204-kube-v1.30.4
- For openstack: when image is builded, set min-disk size to 10g: `openstack image set  ubuntu-2204-kube-v1.30.4  --min-disk 10`

# build cloud images

- prepare and copy packer.PROVIDER.json and packer.PROVIDER.rc into config/ directory
  - packer.PROVIDER.json: contains specific network, security group id, flavor, volume type....
  - packer.PROVIDER.rc: contains specific credentials to your env

- build image

`build.sh`: start the build of kubernetes image based on ubuntu OS
  - you can specify kubernetes version to install (127,128,129,130) according to extra_args_kube_${kube_version}.json
  - you can add extra docker args

in this example, we build kubernetes 1.30.4 version

```
# For openstack
build.sh openstack 130.4
# For outscale
build.sh outscale 130.4
```

```
# sample extra options if needed
# ex1: run packer/ansible in debug mode (confirm each step)
build.sh openstack 130.4 "--env DEBUG=1"
# ex2: add extra host ro resolve host entry
build.sh openstack 130.4 "--add-host identity.openstack.local:10.1.1.1"
```

.... Wait 10/15mn and list the fresh image ...

```
# for openstack
openstack image show ubuntu-2204-kube-v1.30.4
```

- when done: set min-disk size to 10go
```
openstack image set  ubuntu-2204-kube-v1.30.4  --min-disk 10
```

Verify:
```
openstack image list
openstack image show ubuntu-2204-kube-v1.30.4
```

# How to customize image (with ansible)

- add roles in following directory `ansible/roles`
- reference new role in packer.json in variables:  `node_custom_roles_pre": "custom goss YOUR_ROLE_HERE"`
- rebuild image

# Debug with a shell
```
# run.sh
run.sh : contains the docker command line and argument to run image builder with all files included
in the container, run, the following command
make build-PROVIDER-ubuntu-2204
```

## To develop
```
docker pull registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:v0.1.34

# test it
docker run -it --entrypoint /bin/bash  --rm --net=host registry.k8s.io/scl-image-builder/cluster-node-image-builder-amd64:v0.1.34 
```

## To learn how Packer/Ansible roles are defined
```
# to debug (not necessary to build image)
umask 0022
git clone https://github.com/kubernetes-sigs/image-builder.git
```
