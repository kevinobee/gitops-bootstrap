#!/usr/bin/env bash

set -eo pipefail

echo "Install Argo CD into cluster"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Waiting for Argo CD server to start ..."
kubectl wait --for=condition=Available -n argocd deployment.apps/argocd-server --timeout 2m
kubectl wait --for=condition=ContainersReady pod -n argocd --all --timeout 2m

echo "Download Argo CD CLI"
brew install argocd

echo "Configure access to Argo CD"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
HOST=$( kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}' )
PORT=$( kubectl get svc -n argocd argocd-server -o jsonpath='{.spec.ports[0].nodePort}' )
ARGOCD_HOST="${HOST}:${PORT}"
ARGOCD_URL="http://${ARGOCD_HOST}"

echo "Set Argo CD admin password"
password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login $ARGOCD_HOST --username admin --password $password --insecure
argocd account update-password --current-password $password --new-password ChangeMe --insecure
kubectl -n argocd delete secret argocd-initial-admin-secret

echo "Argo CD available - ${ARGOCD_URL}"
