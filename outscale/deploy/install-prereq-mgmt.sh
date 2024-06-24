#!/bin/bash
#
# pre req install docker
mkdir work
cd work
# install kind, kubectl, helm, sops, age
curl -L https://raw.githubusercontent.com/numerique-gouv/dk8s/main/scripts/install-prereq.sh | bash
# install clusterctl
curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v1.7.3/clusterctl-linux-amd64 -o clusterctl
chmod +x clusterctl
sudo mv clusterctl /usr/local/bin/clusterctl
clusterctl version
# install yq
curl -LO https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_amd64.tar.gz
tar -zxvf yq_linux_amd64.tar.gz  ./yq_linux_amd64
rm -rf yq_linux_amd64.tar.gz
chmod +x yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq
