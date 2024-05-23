index: package-capi-cluster \
       package-capi-cluster-addons \
       index-repo
package-capi-cluster:
	helm package capi-cluster -d repo/
package-capi-cluster-addons:
	helm package capi-cluster-addons -d repo/
index-repo:
	helm repo index repo/
