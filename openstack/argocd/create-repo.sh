#!/bin/bash

# create argocd repocreds template
#  equivalent to argocd repocreds add $GIT_URL --type git --username $GIT_USERNAME --password $GIT_PASSWORD

GIT_URL="${GIT_URL:?GIT_URL}"
GIT_USERNAME="${GIT_USERNAME:?GIT_USERNAME}"
GIT_PASSWORD="${GIT_USERNAME:?GIT_PASSWORD}"
http_proxy="${http_proxy:?http_proxy}"
B64_GIT_URL=$(echo -n "$GIT_URL" | base64 -w0)
B64_GIT_USERNAME=$(echo -n "$GIT_USERNAME" | base64 -w0)
B64_GIT_PASSWORD=$(echo -n "$GIT_PASSWORD" | base64 -w0)
B64_HTTP_PROXY=$(echo -n "$http_proxy" | base64 -w0)
# convert git url https://git.com/repo/org -> git-com-repo-org
GIT_NAME=$(echo $GIT_URL |sed -e 's|.*//||g; s|/|-|g;s|\.|-|g')

cat <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repository
  name: $GIT_NAME
  namespace: argocd
data:
  # type git
  type: Z2l0
  # url pattern
  url: $B64_GIT_URL
  proxy: $B64_HTTP_PROXY
EOF
