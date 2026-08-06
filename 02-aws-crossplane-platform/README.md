# AWS and Crossplane Platform Engineering Lab

This project builds a cloud-native Internal Developer Platform on AWS using:

- Amazon EKS
- Terraform
- Crossplane
- Argo CD
- GitHub Actions
- Helm
- Prometheus and Grafana

## Platform Goal

Application teams should be able to deploy workloads and request approved AWS
resources through simple, reusable platform APIs without manually configuring
low-level cloud infrastructure.

## Tool Responsibilities

| Tool | Responsibility |
|------|----------------|
| Terraform | Bootstrap the AWS foundation, including networking, IAM, and EKS |
| Crossplane | Provision application-specific AWS resources through platform APIs |
| GitHub Actions | Build, test, scan, and publish application images |
| Argo CD | Reconcile and deploy Kubernetes workloads from Git |
| Helm | Package reusable applications and platform components |

## Repository Structure

- `terraform/` – AWS foundation and reusable Terraform modules
- `crossplane/` – providers, managed resources, platform APIs, and compositions
- `platform/` – shared Kubernetes platform services
- `gitops/` – Argo CD cluster and application configuration
- `applications/` – sample application workloads
- `docs/` – architecture, requirements, diagrams, and decisions
- `scripts/` – supporting automation
