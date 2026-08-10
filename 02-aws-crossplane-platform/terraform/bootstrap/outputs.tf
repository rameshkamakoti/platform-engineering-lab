output "terraform_state_bucket_name" {
  description = "S3 bucket used to store Terraform remote state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "vpc_id" {
  description = "ID of the platform VPC"
  value       = aws_vpc.platform.id
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs"
  value = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "eks_security_group_id" {
  description = "Security group used by the EKS platform"
  value       = aws_security_group.eks.id
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by the EKS managed node group"
  value       = aws_iam_role.eks_node.arn
}



