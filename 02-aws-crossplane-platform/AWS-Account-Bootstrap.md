# Lesson 02 – AWS Account Bootstrap

## Objective

Prepare a brand-new AWS account following Platform Engineering best practices.

---

# Learning Objectives

After completing this lesson, I should be able to:

- Create a secure AWS account
- Understand Root User vs IAM User
- Enable MFA
- Configure AWS CLI
- Verify authentication
- Prepare the account for Infrastructure as Code

---

# Architecture

                Root User
                    │
          (Account Administration)
                    │
                    ▼
          IAM Administrator User
                    │
                    ▼
              AWS CLI (Local)
                    │
                    ▼
               Terraform
                    │
                    ▼
             AWS Resources

---

# Step 1 - Create AWS Account

Website

https://aws.amazon.com/free

Account Name

```
ramesh.cloud
```

Support Plan

```
Basic (Free)
```

Region

```
us-east-2
```

---

# Step 2 - Secure Root Account

Login as Root User.

Navigate to

```
Account
    ↓
Security Credentials
    ↓
Multi-Factor Authentication (MFA)
```

Configured

✅ Google Authenticator / Microsoft Authenticator

Purpose

Protect the AWS Root account.

---

# Step 3 - Create Administrator IAM User

Navigate

```
IAM
    ↓
Users
    ↓
Create User
```

Username

```
platform-admin
```

Permissions

```
AdministratorAccess
```

Console Access

```
Enabled
```

---

# Step 4 - Generate CLI Credentials

Navigate

```
IAM
    ↓
Users
    ↓
platform-admin
    ↓
Security Credentials
    ↓
Create Access Key
```

Use Case

```
Command Line Interface (CLI)
```

Generated

- Access Key ID
- Secret Access Key

Saved securely.

---

# Step 5 - Install Required Tools

Update Ubuntu

```bash
sudo apt update
```

Install common packages

```bash
sudo apt install -y \
curl \
wget \
unzip \
zip \
git \
jq \
gnupg \
software-properties-common \
ca-certificates \
lsb-release
```

Verify

```bash
git --version

jq --version

curl --version
```

---

# Step 6 - Install AWS CLI

Download

```bash
cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"
```

Extract

```bash
unzip -q awscliv2.zip
```

Install

```bash
sudo ./aws/install
```

Verify

```bash
aws --version
```

Cleanup

```bash
rm -rf /tmp/aws /tmp/awscliv2.zip
```

---

# Step 7 - Install Terraform

Add Repository

```bash
wget -O- https://apt.releases.hashicorp.com/gpg \
| gpg --dearmor \
| sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

Configure Repository

```bash
echo \
"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(. /etc/os-release && echo "$VERSION_CODENAME") main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Install

```bash
sudo apt update

sudo apt install terraform -y
```

Verify

```bash
terraform version
```

---

# Step 8 - Install kubectl

Download

```bash
cd /tmp

curl -LO \
"https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install

```bash
sudo install \
-o root \
-g root \
-m 0755 \
kubectl \
/usr/local/bin/kubectl
```

Verify

```bash
kubectl version --client
```

Cleanup

```bash
rm -f /tmp/kubectl
```

---

# Step 9 - Install Helm

Import GPG Key

```bash
curl -fsSL \
https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
| gpg --dearmor \
| sudo tee /usr/share/keyrings/helm.gpg > /dev/null
```

Add Repository

```bash
echo \
"deb [signed-by=/usr/share/keyrings/helm.gpg] \
https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
| sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
```

Install

```bash
sudo apt update

sudo apt install helm -y
```

Verify

```bash
helm version
```

---

# Step 10 - Configure AWS CLI

```bash
aws configure
```

Provide

```
AWS Access Key ID

AWS Secret Access Key

Region
```

```
us-east-2
```

Output

```
json
```

---

# Step 11 - Verify Authentication

Command

```bash
aws sts get-caller-identity
```

Expected

```json
{
    "Account": "777929922779",
    "Arn": "arn:aws:iam::777929922779:user/platform-admin"
}
```

This confirms Terraform and AWS CLI are authenticated using the IAM administrator user.

---

# Commands Executed (Quick Reference)

```bash
sudo apt update

sudo apt install -y curl wget unzip zip git jq gnupg software-properties-common ca-certificates lsb-release

aws --version

terraform version

kubectl version --client

helm version

aws configure

aws sts get-caller-identity
```

---

# Verification Checklist

✅ AWS Account Created

✅ Root MFA Enabled

✅ platform-admin Created

✅ AdministratorAccess Attached

✅ AWS CLI Installed

✅ Terraform Installed

✅ kubectl Installed

✅ Helm Installed

✅ AWS CLI Configured

✅ STS Authentication Successful

---

# Key Concepts Learned

## Root User

- Used only for account administration
- Never use for Terraform
- Protected with MFA

## IAM User

Used for daily engineering work.

## AWS CLI

Provides command-line access to AWS.

## STS

Verifies the authenticated identity.

---

# Production Best Practices

- Never use Root User for Infrastructure as Code
- Enable MFA immediately
- Use IAM Users or IAM Roles
- Use one AWS Region for the platform
- Verify credentials before provisioning infrastructure

---

# Common Mistakes

❌ Using Root User for Terraform

❌ Forgetting MFA

❌ Losing Secret Access Key

❌ Using multiple AWS Regions

❌ Skipping authentication verification

---

# Lesson Summary

Today we securely bootstrapped a new AWS account by enabling MFA on the Root account, creating an IAM administrator user, installing the required CLI tools, configuring the AWS CLI, and verifying authentication using STS.

This establishes the secure foundation required before provisioning infrastructure with Terraform.

---

# Next Lesson

Lesson 03

Terraform Bootstrap

Topics

- Terraform State
- Remote Backend
- Amazon S3
- DynamoDB State Locking
- First Terraform Project
