Canary EKS Deployment Project

  This project demonstrates a canary deployment setup for an application running on Amazon EKS (Elastic Kubernetes Service).
  It uses GitHub Actions for CI/CD, Docker for containerization, and Terraform for infrastructure management.

Project Structure

canary-eks/
├── .github/
│   └── workflows/
│       ├── deploymentv1.yaml
│       ├── deploymentv2.yaml
│       └── infra.yaml
├── kubernetes/
│   ├── deploymentv1.yaml
│   ├── deploymentv2.yaml
│   ├── service1.yaml
│   └── service-lb.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── v1/
│   ├── Dockerfile
│   ├── app.js
│   └── package.json
└── v2/
    ├── Dockerfile
    ├── app.js
    └── package.json

 Components

 GitHub Actions Workflows

  1. deploymentv1.yaml: 
   - Triggered when changes are pushed to the `v1/` directory.
   - Builds and pushes the V1 Docker image to Docker Hub.
   - Deploys the V1 application to EKS.

  2. deploymentv2.yaml:
   - Triggered when changes are pushed to the `v2/` directory.
   - Builds and pushes the V2 Docker image to Docker Hub.
   - Deploys the V2 application to EKS as a canary release.
   - Scales both V1 and V2 deployments to ensure a 50/50 traffic split.

  3. infra.yaml:
   - Triggered when changes are pushed to the `terraform/` directory.
   - Sets up and applies Terraform configurations to manage AWS infrastructure.

Kubernetes Manifests
  
  1. deploymentv1.yaml: Kubernetes deployment for the V1 application.
  2. deploymentv2.yaml: Kubernetes deployment for the V2 application (canary).
  3. service1.yaml: Kubernetes service for routing traffic to the V1 pods.
  4. service-lb.yaml: Load balancer service for distributing traffic between V1 and V2.

Terraform Files

  1. main.tf: Main Terraform configuration for setting up the EKS cluster and related resources.
  2. variables.tf: Variable definitions for the Terraform configuration.
  3. outputs.tf: Output definitions for important information after Terraform apply.

Application Versions

  Both `v1/` and `v2/` directories contain:
  - Dockerfile: Instructions for building the Docker image.
  - app.js: The main application file (presumably a Node.js application).
  - package.json: Node.js package configuration.

Workflow

  1. Infrastructure Setup:
   - Push changes to the `terraform/` directory.
   - The `infra.yaml` workflow runs, applying Terraform configurations to set up the EKS cluster and related AWS resources.

  2. V1 Deployment:
   - Push changes to the `v1/` directory.
   - The `deploymentv1.yaml` workflow builds the V1 Docker image, pushes it to Docker Hub, and deploys it to the EKS cluster.

  3. Canary Deployment (V2):
   - Push changes to the `v2/` directory.
   - The `deploymentv2.yaml` workflow builds the V2 Docker image, pushes it to Docker Hub, and deploys it alongside V1.
   - The workflow scales both V1 and V2 deployments to create a 50/50 traffic split, implementing the canary release.

Canary Release Process

  The canary release is implemented by:
  1. Maintaining two separate deployments (V1 and V2) in the EKS cluster.
  2. Using a single load balancer service (`service-lb.yaml`) to distribute traffic between V1 and V2 pods.
  3. Scaling the V1 and V2 deployments equally to achieve a 50/50 traffic split.

  This setup allows for easy rollback by adjusting the scaling of V1 and V2 deployments or updating the load balancer configuration.

 Security Notes

  - Sensitive information (like AWS credentials and Docker Hub access tokens) is stored as GitHub Secrets and accessed securely in the workflows.
  - Make sure to review and adjust IAM permissions for the AWS account used in this setup to follow the principle of least privilege.

 Monitoring and Rollback

  To fully leverage this canary deployment setup:
  1. Implement monitoring and logging to compare the performance and error rates of V1 and V2 .
  2. Create additional scripts or workflows for easy rollback if issues are detected with the V2 deployment.

 Next Steps

  - Implement gradual traffic shifting (e.g., 90/10, then 80/20, etc.) instead of an immediate 50/50 split.
  - Add automated testing in the CI/CD pipeline before deploying to production.
  - Implement a blue/green deployment strategy as an alternative to canary releases for certain updates.
