# ADR-003: Use Argo CD for Kubernetes Delivery

## Status

Accepted

## Context

The platform requires a repeatable, auditable, and declarative deployment model
for applications and shared Kubernetes services.

## Decision

Use Argo CD as the Kubernetes continuous-delivery and reconciliation tool.

## Consequences

Benefits:

- Git is the source of truth.
- Changes are auditable.
- Argo CD detects configuration drift.
- Rollback can be performed through Git history.

Trade-offs:

- Teams must follow GitOps practices.
- Manual cluster changes may be reverted.
- Repository permissions become part of the deployment security model.
