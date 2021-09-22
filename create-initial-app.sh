#!/usr/bin/env bash

set -eo pipefail

echo "Create Argo CD application from Git repository"

# Create application from Git repository
argocd app create applications --repo https://github.com/kevinobee/gitops-bootstrap.git --path apps --dest-server https://kubernetes.default.svc --dest-namespace default

# Sync the application
argocd app sync applications
