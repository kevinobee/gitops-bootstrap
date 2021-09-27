# Tasks

1. Nginx Ingress

    ```argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc```

1. Metal LB

1. Argo CD app of apps

1. Bitnami Sealed Secrets

1. NFS Storage Provider for local volumes
