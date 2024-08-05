
# P2P DevOps Test

This repository contains the infrastructure and application code for deploying a web application using Kubernetes.
It's managed through ArgoCD for GitOps, and provisioned using Terraform.

## Structure

- **`.github/workflows`**: GithubActions to manage CI and CD.
- **`charts/argocd-apps`**: Helm chart for the web application.
- **`charts/cluster-bootstrap`**: Helm chart for the web application.
- **`charts/webapp`**: Helm chart for the web application.
- **`/kubernetes/configs`**: Raw Kubernetes manifests for base infrastructure like namespaces and secrets.
- **`/my-k8s-configs`**: Kubernetes configurations using Tanka and Jsonnet.
- **`/terraform`**: Terraform configurations for provisioning infrastructure on Google Cloud and setting up ArgoCD.
- **`Dockerfile`**: Dockerfile for building the web application's container image.
- **`main.go`**: The main Go application source file.

## Prerequisites

To deploy this project, ensure you have the following installed:

- Access to a Kubernetes cluster
- `kubectl` configured for your cluster
- Terraform

## Getting Started

### Deploying with Terraform

1. **Initialize Terraform**

   Navigate to the `/terraform/gke` directory:

   ```sh
   terraform init
   terraform apply
   ```

2. **Deploy ArgoCD**

   Use the Terraform module in `/terraform/argo-cd`:

   ```sh
   terraform apply
   ```
### Continuous Deployment with ArgoCD

After setting up your infrastructure with Terraform and deploying your applications with Helm, ArgoCD automates the deployment process by syncing the state of your Kubernetes resources with the configurations defined in your Git repository. Ensure that `tk export` is executed whenever Jsonnet files are updated to reflect changes in ArgoCD-managed applications.

## Development

For local development, build the Docker container and perform GET on port 8080:

```sh
docker build -t juliopedrosa/webapp:latest
docker run -p 8080:3000 -d juliopedrosa/webapp:latest
curl localhost:8080
```

Run and test the application locally:

```sh
go test -v
go run main.go
```

## Tech Debts
- Move App of Apps setup to another repository.
- Create NetworkPolicies to block traffic between namespace environments
- Create script to handle MAJOR releases
- Create a S3 bucket and DynamoDB table to manage statefile and lockfile
