# rolling update

https://cluster-api.sigs.k8s.io/tasks/upgrading-clusters

Order:
- ensure that relevant infrastructure machine templates reference the appropriate image for the Kubernetes version.
- upgrade the control plane
- create new workers machines with update version
- remove old workers machines.
- MachineTemplate resources are immutable

With this helm chart version, follow steps
Change the values files and you need to commit and deploy each step
- commit to change version N+1 for ctrlplane (wait node ready)
- commit to create version N+1 worker pool (wait node ready)
- commit to delete version N worker pool (wait pod is moved and wait node is retired)

Create cluster with:
- ctrlplane with version N
- upgrade ctrlplane with version N+1
- worker pool with version N (md-0)
- to upgrade: create new worker pool with version N+1) (md-1)
- then remove worker pool with version N
