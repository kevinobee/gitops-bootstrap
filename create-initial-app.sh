#!/usr/bin/env bash

set -eo pipefail

echo "Create Argo CD application from Git repository"
argocd app create applications --repo https://github.com/kevinobee/gitops-bootstrap.git --path yamls --dest-server https://kubernetes.default.svc --dest-namespace default --upsert --revision apps --self-heal --sync-policy automated --sync-option Prune=true --auto-prune
