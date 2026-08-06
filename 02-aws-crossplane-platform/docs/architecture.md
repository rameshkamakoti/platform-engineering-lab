# Platform Architecture

## High-Level Architecture

The platform uses AWS, Kubernetes, Terraform, Crossplane, Argo CD, Helm, and
GitHub Actions to provide automated application delivery and self-service
infrastructure.

## Component Responsibilities

### Terraform

Terraform manages the foundational infrastructure required before Kubernetes
and Crossplane are available.

Terraform will manage:

- Terraform remote state
- VPC
- Public and private subnets
- Route tables
- Internet Gateway
- NAT Gateway
- Amazon EKS
- Managed node groups
- Foundational IAM roles and policies

Terraform is the Day 0 infrastructure tool.

### Crossplane

Crossplane runs inside Amazon EKS and manages application-specific AWS
infrastructure through Kubernetes APIs.

Crossplane will manage:

- S3 buckets
- RDS databases
- Application IAM roles
- Security groups
- Application-specific cloud resources
- Composite platform APIs

Crossplane is the Day 1 and Day 2 infrastructure control plane.

### GitHub Actions

GitHub Actions manages continuous integration.

It will:

- Check out source code
- Compile applications
- Run tests
- Perform security scans
- Build container images
- Push images to Amazon ECR
- Update GitOps configuration

### Argo CD

Argo CD manages continuous delivery.

It will:

- Watch Git repositories
- Deploy Kubernetes resources
- Detect configuration drift
- Reconcile desired state
- Support Git-based rollback

### Helm

Helm packages reusable Kubernetes applications and platform services.

It will be used for:

- Application charts
- Argo CD
- Crossplane
- Prometheus
- Grafana
- AWS Load Balancer Controller

## Application Delivery Flow

1. A developer pushes code to GitHub.
2. GitHub Actions runs tests and security checks.
3. GitHub Actions builds a container image.
4. The image is pushed to Amazon ECR.
5. The GitOps repository is updated with the new image version.
6. Argo CD detects the Git change.
7. Argo CD deploys the application to Amazon EKS.
8. The AWS Load Balancer Controller exposes the application through an ALB.
9. Prometheus and Grafana provide metrics and dashboards.
10. Logs are forwarded to a centralized logging destination.

## Infrastructure Request Flow

1. A developer submits a platform resource request in YAML.
2. The request is stored in Git.
3. Argo CD applies the Crossplane custom resource.
4. Crossplane reconciles the desired state.
5. Crossplane provisions the required AWS resources.
6. Connection details are published securely for the application.

## Network Architecture

The AWS environment will contain:

- One VPC
- Multiple Availability Zones
- Public subnets for internet-facing load balancers and NAT Gateways
- Private subnets for EKS worker nodes
- Private database subnets for Amazon RDS
- Security groups controlling traffic between platform components

## Traffic Flow

External traffic follows this path:

User
→ Route 53
→ AWS Application Load Balancer
→ Kubernetes Ingress
→ Kubernetes Service
→ Application Pod

## Platform API Goal

The final platform should allow developers to submit a resource such as:

```yaml
apiVersion: platform.acme.io/v1alpha1
kind: Application
metadata:
  name: payment-api
spec:
  environment: dev
  database:
    enabled: true
  objectStorage:
    enabled: true
  ingress:
    enabled: true
