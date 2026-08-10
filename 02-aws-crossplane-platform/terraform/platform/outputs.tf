output "foundation_vpc_id" {
  value = data.terraform_remote_state.foundation.outputs.vpc_id
}

output "foundation_private_subnets" {
  value = data.terraform_remote_state.foundation.outputs.private_app_subnet_ids
}

output "foundation_cluster_role" {
  value = data.terraform_remote_state.foundation.outputs.eks_cluster_role_arn
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.platform.name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.platform.endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = aws_eks_cluster.platform.version
}

output "payment_api_ecr_url" {
  description = "ECR repository URL for Payment API"
  value       = aws_ecr_repository.payment_api.repository_url
}