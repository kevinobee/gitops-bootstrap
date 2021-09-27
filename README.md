# GitOps Bootstrap

Project to explore bootstrapping Git driven Kubernetes (k8s) automation tooling.

## Prerequisites

1. [Kubernetes](https://kubernetes.io/),  [kubectl](https://kubernetes.io/docs/tasks/tools/) and a running Kubernetes cluster.

1. The [Homebrew](https://docs.brew.sh/Homebrew-on-Linux) package manager.

## Getting Started

1. Setup Argo CD

    Run the ```./install-argocd.sh``` script to perform the following tasks.

    1. Install Argo CD into cluster

        ```Shell
        kubectl create namespace argocd
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        ```

    1. Download Argo CD CLI

        ```Shell
        brew install argocd
        ```

    1. Access the Argo CD API Server

        ```Shell
        # Service Type Load Balancer
        kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

        # Port Forwarding
        kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
        ```

    1. Login to Argo CD and update admin password

        ```Shell
        # Retrieve initial admin password from secret in argocd namespace
        initialPassword=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

        # Login to Argo CD
        argocd login localhost:8080 --username admin --password $initialPassword --insecure

        # Change the initial admin password
        argocd account update-password --current-password $initialPassword --new-password ChangeMe

        # Remove the initial admin secret
        kubectl -n argocd delete secret argocd-initial-admin-secret
        ```

1. Create Argo CD application from Git repository

    Run the ```./create-initial-app.sh``` script to perform the following tasks.

    ```Shell
    # Create application from Git repository
    argocd app create applications --repo https://github.com/kevinobee/gitops-bootstrap.git --path apps --dest-server https://kubernetes.default.svc --dest-namespace default

    # Sync the application
    argocd app sync applications
    ```

## Next Tasks

1. Add Prometheus monitoring

    Run ```./install-monitoring.sh``` to install the Prometheus monitoring stack using Host installed Helm

<!-- 1. [Gitea](https://gitea.com/) will be used in the repository examples to provide a locally hosted Git repository that can be monitored by and interact with Argo CD running in the cluster. -->

## References

* [Argo CD: Getting started](https://argo-cd.readthedocs.io/en/stable/getting_started/)

<!-- * [Gitea: Git with a cup of tea](https://gitea.com/) -->

* [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)

## Further Reading

* [Automation of Everything - How To Combine Argo Events, Workflows & Pipelines, CD, and Rollouts](https://github.com/vfarcic/argo-combined-demo)
