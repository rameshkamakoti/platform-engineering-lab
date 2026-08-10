# Lesson 04 – Terraform Bootstrap (Part 1)
## Building a Production-Ready Terraform Foundation

---

# Lesson Objective

In this lesson, we begin building our first production-quality Terraform project.

Unlike most Terraform tutorials that immediately create cloud resources, this lesson focuses on understanding how Terraform itself works before provisioning infrastructure.

By the end of this lesson, you will understand:

- Terraform execution flow
- Why Terraform projects are split into multiple files
- Provider configuration
- Variables
- Locals
- Default Tags
- Enterprise project structure
- Production engineering best practices

---

# Learning Objectives

After completing this lesson, I should be able to:

- Explain how Terraform executes configuration
- Configure the AWS Provider
- Understand Terraform Providers
- Differentiate Variables and Locals
- Configure reusable project settings
- Follow enterprise Terraform project structure

---

# Business Problem

Imagine joining a Platform Engineering team responsible for managing infrastructure across hundreds of AWS accounts.

Without a standard Terraform project structure:

- Every engineer writes Terraform differently.
- Resources are inconsistently tagged.
- Regions are hardcoded.
- Code becomes difficult to maintain.
- Infrastructure becomes difficult to scale.

The solution is to standardize every Terraform project.

---

# Architecture

```
                    terraform init
                           │
                           ▼
                  Read versions.tf
                           │
                           ▼
                 Download Providers
                           │
                           ▼
                  Read providers.tf
                           │
                           ▼
             Authenticate with AWS
                           │
                           ▼
                 Read variables.tf
                           │
                           ▼
              Load terraform.tfvars
                           │
                           ▼
                   Evaluate locals
                           │
                           ▼
                Read all Resources
                           │
                           ▼
                 Build Execution Graph
                           │
                           ▼
                    terraform plan
                           │
                           ▼
                    terraform apply
```

---

# Important Concept

Terraform **does not execute files one-by-one.**

This is one of the biggest misconceptions among beginners.

Terraform loads **all `.tf` files** in the current directory and combines them into a single configuration before creating an execution graph.

Therefore,

```
versions.tf

providers.tf

variables.tf

locals.tf

main.tf

outputs.tf
```

are all treated as one logical configuration.

---

# Enterprise Terraform Project Structure

```
terraform/

    bootstrap/

        versions.tf

        providers.tf

        variables.tf

        locals.tf

        main.tf

        outputs.tf

        terraform.tfvars
```

Each file has a single responsibility.

---

# File 1 – versions.tf

Purpose

Configure Terraform itself.

Example

```hcl
terraform {

  required_version = ">= 1.15.0"

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 6.0"

    }

  }

}
```

---

## Explanation

### terraform

Configures the Terraform engine.

### required_version

Ensures every engineer uses a supported Terraform version.

Without this, one engineer may use Terraform 1.15 while another uses Terraform 0.14, resulting in incompatible behavior.

### required_providers

Specifies which provider plugins Terraform should download.

### aws

Downloads the official AWS Provider maintained by HashiCorp.

### version = "~> 6.0"

Allows:

```
6.1

6.5

6.10

6.40
```

Rejects:

```
7.0
```

This prevents unexpected breaking changes.

---

# Real World Scenario

Imagine Visa has 500 Terraform repositories.

Today:

AWS Provider 6.4

Tomorrow:

HashiCorp releases Provider 7.0.

If every repository automatically downloads the latest provider, production deployments may fail without any code changes.

By pinning the provider version, Platform Engineers control when upgrades happen.

---

# File 2 – providers.tf

Purpose

Configure communication between Terraform and AWS.

Example

```hcl
provider "aws" {

  region = var.aws_region

  default_tags {

    tags = local.common_tags

  }

}
```

---

## How Terraform Authenticates

Terraform automatically checks credentials in the following order:

1. Environment Variables

```
AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY
```

2. AWS CLI

```
~/.aws/credentials
```

3. AWS Named Profiles

4. IAM Roles

5. IAM Identity Center (SSO)

Since we already executed:

```bash
aws configure
```

Terraform automatically uses those credentials.

---

# Why Not Hardcode Region?

Bad Example

```hcl
region = "us-east-2"
```

Good Example

```hcl
region = var.aws_region
```

Imagine Visa deploys infrastructure to:

- us-east-1
- us-east-2
- eu-west-1

Using variables allows the same Terraform code to be reused across all environments.

---

# Default Tags

Purpose

Automatically apply common tags to every AWS resource.

Example

```hcl
default_tags {

    tags = local.common_tags

}
```

Without default tags, every resource must manually define tags.

With default tags, Terraform automatically applies them to supported AWS resources.

---

# Real World Scenario

Finance asks:

> "How much did the Merchant Platform cost last month?"

Without tags:

Impossible.

With tags:

```
Project = Merchant

Environment = Prod

Owner = Platform
```

AWS Cost Explorer can group costs by tags.

This is why enterprise environments enforce tagging standards.

---

# File 3 – variables.tf

Purpose

Accept external inputs.

Example

```hcl
variable "aws_region" {

  description = "AWS Region"

  type = string

  default = "us-east-2"

}

variable "project_name" {

  description = "Project Name"

  type = string

  default = "platform-engineering-lab"

}

variable "environment" {

  description = "Environment"

  type = string

  default = "bootstrap"

}
```

---

# Why Variables?

Think of Variables exactly like Python function parameters.

Python

```python
def deploy(region):
```

Terraform

```hcl
variable "aws_region"
```

Instead of modifying source code, we pass different values.

---

# File 4 – locals.tf

Purpose

Store reusable computed values.

Example

```hcl
locals {

    common_tags = {

        Project = var.project_name

        Environment = var.environment

        ManagedBy = "Terraform"

        Owner = "Platform Engineering"

        Repository = "platform-engineering-lab"

    }

}
```

---

# Variables vs Locals

Variables

- Input from outside Terraform
- User configurable
- Environment specific

Examples

- AWS Region
- Environment
- Project Name

---

Locals

- Computed inside Terraform
- Not user input
- Used repeatedly

Examples

- Common Tags
- Resource Names
- Naming Standards
- Prefixes

---

# Real World Scenario

Suppose Finance introduces a new mandatory tag:

```
Compliance = PCI
```

Without Locals

Every Terraform resource must be modified individually.

Potentially:

```
2000 Resources
```

With Locals

Only one file changes:

```
locals.tf
```

Every resource automatically receives the new tag.

---

# Production Engineering Principles

Never hardcode:

- Region
- Environment
- Project Name
- Resource Names

Always use Variables.

---

Never duplicate:

- Tags
- Naming Conventions

Always use Locals.

---

Pin Provider Versions.

Never use:

```
latest
```

Always control change.

---

# Commands Executed

Navigate to bootstrap directory

```bash
cd ~/projects/platform-engineering-lab/02-aws-crossplane-platform/terraform/bootstrap
```

Create files

```bash
touch versions.tf

touch providers.tf

touch variables.tf

touch locals.tf
```

Initialize Terraform

```bash
terraform init
```

(We will execute this after completing the remaining Terraform files.)

---

# Interview Knowledge

## Why isn't the AWS Provider built into Terraform?

Terraform is provider-based.

Instead of embedding AWS, Azure, Kubernetes, GitHub, Helm, Datadog, and thousands of APIs inside Terraform, each integration is delivered as a plugin.

This makes Terraform lightweight and extensible.

---

## Why pin provider versions?

To avoid unexpected breaking changes introduced by major provider upgrades.

Platform Engineering teams test provider upgrades before rolling them out across all repositories.

---

## Why use Variables?

To make Terraform reusable across environments.

---

## Why use Locals?

To eliminate duplication and centralize computed values.

---

# Common Mistakes

❌ Hardcoding AWS Regions

❌ Using latest Provider Versions

❌ Duplicating Tags

❌ Writing everything inside main.tf

❌ Hardcoding Credentials

---

# Production Best Practices

- Separate Terraform files by responsibility.
- Pin provider versions.
- Never hardcode credentials.
- Use AWS CLI or IAM Roles for authentication.
- Standardize Tags.
- Use Variables for external configuration.
- Use Locals for reusable internal values.

---

# Knowledge Check

## Level 1 – Fundamentals

1. Why doesn't Terraform require AWS Access Keys inside provider.tf?

2. Why should the AWS Region be stored as a Variable?

3. Explain the difference between Variables and Locals.

---

## Level 2 – Platform Engineering

Visa now deploys applications into:

- us-east-1
- us-east-2
- eu-west-1

How would Variables help avoid duplicate Terraform projects?

---

## Level 3 – Production Scenario

Finance introduces a mandatory tag:

```
Compliance = PCI
```

More than 2,000 Terraform resources must now include this tag.

How would using:

- Variables
- Locals
- Default Tags

reduce engineering effort?

---

# Lesson Summary

In this lesson, we learned how Terraform loads configuration files, why production projects separate Terraform into multiple files, how the AWS Provider authenticates using AWS CLI credentials, and how Variables, Locals, and Default Tags help create reusable, maintainable, and enterprise-ready Infrastructure as Code.

These concepts form the foundation for every Terraform project we build moving forward.

---

# Next Lesson

Lesson 04 – Terraform Bootstrap (Part 2)

Topics:

- main.tf
- S3 Backend
- Bucket Versioning
- Server-Side Encryption
- DynamoDB Lock Table
- terraform fmt
- terraform validate
- terraform plan
- terraform apply

---

# Engineering Journal

## What did I learn today?

## What surprised me?

## What problems did I encounter?

## How did I solve them?

## What would I improve?

## What would I do differently in production?

## Key Takeaways
