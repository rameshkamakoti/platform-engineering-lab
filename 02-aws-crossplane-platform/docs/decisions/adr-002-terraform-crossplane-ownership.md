# ADR-002: Separate Terraform and Crossplane Ownership

## Status

Accepted

## Context

Crossplane requires a running Kubernetes cluster, while the EKS cluster itself
must be created before Crossplane can operate.

Using Terraform and Crossplane without clear ownership could result in resource
conflicts and configuration drift.

## Decision

Use Terraform for foundational infrastructure and Crossplane for
application-specific infrastructure.

Terraform owns:

- Remote state
- VPC
- Subnets
- Routing
- EKS
- Managed node groups
- Foundational IAM

Crossplane owns:

- Application S3 buckets
- Application databases
- Application IAM roles
- Application-specific security groups
- Composite platform APIs

## Consequences

Benefits:

- Clear lifecycle separation
- Reliable cluster bootstrap
- Kubernetes-native self-service after platform installation

Trade-offs:

- Two infrastructure tools must be maintained.
- Ownership rules must be documented and enforced.
