#!/usr/bin/env bash

set -eo pipefail

echo "Create Argo CD application from Git repository"
argocd app create applications --repo https://github.com/kevinobee/gitops-bootstrap.git --path yamls --dest-server https://kubernetes.default.svc --dest-namespace default --upsert --revision apps --self-heal --sync-policy automated --sync-option Prune=true --auto-prune

echo "Install Helm repositories"
argocd repo add https://charts.helm.sh/stable --type helm --name stable
argocd repo add https://prometheus-community.github.io/helm-charts --type helm --name prometheus-community
