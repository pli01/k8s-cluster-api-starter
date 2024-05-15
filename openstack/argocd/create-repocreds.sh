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

cat <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repo-creds
  name: git-repo-infra-template
  namespace: argocd
data:
  # url pattern
  url: $B64_GIT_URL
  username: $B64_GIT_USERNAME
  password: $B64_GIT_PASSWORD
  proxy: $B64_HTTP_PROXY
EOF
