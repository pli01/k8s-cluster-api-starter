#!/bin/bash

set -eu -o pipefail
set -x

# download bootstrap script
k8s_capi_boostrap_url=https://github.com/pli01/k8s-cluster-api-starter
repo_dir=$(basename $k8s_capi_boostrap_url)
branch=bootstrap

# git clone
git clone $k8s_capi_boostrap_url
cd $repo_dir
git checkout $branch

# bootstrap
cd openstack/deploy
bash ./scripts/install_seed_mgmt.sh
