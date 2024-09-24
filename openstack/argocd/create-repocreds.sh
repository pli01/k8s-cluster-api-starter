#!/bin/bash

# create argocd repocreds template
#  equivalent to argocd repocreds add $GIT_URL --type git --username $GIT_USERNAME --password $GIT_PASSWORD

GIT_URL="${GIT_URL:?GIT_URL}"
GIT_USERNAME="${GIT_USERNAME:?GIT_USERNAME}"
GIT_PASSWORD="${GIT_PASSWORD:?GIT_PASSWORD}"
http_proxy="${http_proxy:-}"
B64_GIT_URL=$(echo -n "$GIT_URL" | openssl base64 -A)
B64_GIT_USERNAME=$(echo -n "$GIT_USERNAME" | openssl base64 -A)
B64_GIT_PASSWORD=$(echo -n "$GIT_PASSWORD" | openssl base64 -A)
GIT_NAME=$(echo $GIT_URL |sed -e 's|.*//||g; s|/|-|g;s|\.|-|g')
[[ -n "$http_proxy" ]] && exportB64_HTTP_PROXY=$(echo -n "$http_proxy" | openssl base64 -A)

cat <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repo-creds
  name: $GIT_NAME
  namespace: argocd
data:
  # url pattern
  url: $B64_GIT_URL
  username: $B64_GIT_USERNAME
  password: $B64_GIT_PASSWORD
EOF
[[ -n "$http_proxy" ]] && echo "  proxy: $B64_HTTP_PROXY"
