
# P2P DevOps Test

This repository contains the infrastructure and application code for deploying a web application using Kubernetes.
It's managed through ArgoCD for GitOps, and provisioned using Terraform.

## Structure

- **`.github/workflows`**: GithubActions to manage CI and CD using.
- **`charts/argocd-apps`**: Helm chart for ArgoCD Apps and AppSets.
- **`charts/cluster-bootstrap`**: Helm chart for the required applications (e.g ALB Controller, External DNS, etc).
- **`charts/webapp`**: Helm chart for the web application.
- **`terraform`**: Terraform configurations for provisioning infrastructure onA AWS and setting up ArgoCD.
- **`Dockerfile`**: Dockerfile for building the web application's container image.
- **`main.go`**: The application source file.
- **`main_test.go`**: The application test source file.

## Prerequisites

To deploy this project, ensure you have the following installed:

- Access to a Kubernetes cluster
- Terraform
- Make
- Docker
- GitHub CLI

## Getting Started

### Deploying with Terraform

1. **Initialize Terraform**

   Navigate to the `terraform/` directory:

   ```sh
   terraform init
   terraform apply
   ```

## Development

For local development, build the Docker container and perform GET on port 8080:

```sh
make build && make
curl localhost:8080
```

Run and test the application locally:

```sh
go test -v
go run main.go
```

### CI-CD - GitFlow

###### Long-lived branches

- `origin/main`
   - Always reflects a production-ready state.
- `origin/develop`
   - Always reflects a state with the latest delivered development changes for the next release.

###### Release

```bash
make release # from develop
```

###### Hotfix

```bash
make hotfix # from main
```
## Tech Debts
- Move App of Apps setup to another repository.
- Create NetworkPolicies to block traffic between namespace environments
- Create script to handle MAJOR releases
- Create a S3 bucket and DynamoDB table to manage statefile and lockfile
