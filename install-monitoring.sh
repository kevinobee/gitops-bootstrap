#!/usr/bin/env bash

## How to Install Prometheus and Grafana on Kubernetes using Helm 3
## ref: https://www.fosstechnix.com/install-prometheus-and-grafana-on-kubernetes-using-helm/

set -eo pipefail

echo "Install helm repositories"
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# argocd repo add https://charts.helm.sh/stable --type helm --name stable
# argocd repo add https://prometheus-community.github.io/helm-charts --type helm --name prometheus-community

echo "Install Prometheus stack"
helm install stable prometheus-community/kube-prometheus-stack
# argocd app create prometheus --repo https://gitlab.com/kevinobee/gitops-demo.git --path prometheus --dest-server https://kubernetes.default.svc --dest-namespace prom


echo "Expose Prometheus and Grafana services using Load Balancer"
kubectl patch svc stable-kube-prometheus-sta-prometheus -n default -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc stable-grafana -n default -p '{"spec": {"type": "LoadBalancer"}}'

echo "Prometheus stack available"
echo $( kubectl get svc -n default -o wide && echo )
