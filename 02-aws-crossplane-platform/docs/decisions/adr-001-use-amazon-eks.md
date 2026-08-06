# ADR-001: Use Amazon EKS

## Status

Accepted

## Context

The platform requires a managed Kubernetes environment integrated with AWS
networking, IAM, storage, load balancing, and Crossplane.

## Decision

Use Amazon EKS as the Kubernetes platform.

## Consequences

Benefits:

- AWS manages the Kubernetes control plane.
- Native integration with IAM, ECR, ALB, EBS, EFS, and CloudWatch.
- Suitable for running Crossplane and Argo CD.
- Supports managed node groups and autoscaling.

Trade-offs:

- EKS introduces AWS-specific integrations.
- The platform has ongoing cloud costs.
- Cluster upgrades and add-on compatibility still require platform ownership.
