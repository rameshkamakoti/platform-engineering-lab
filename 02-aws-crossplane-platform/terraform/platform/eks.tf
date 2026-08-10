resource "aws_eks_cluster" "platform" {
  name     = var.cluster_name
  role_arn = data.terraform_remote_state.foundation.outputs.eks_cluster_role_arn

  vpc_config {
    subnet_ids = data.terraform_remote_state.foundation.outputs.private_app_subnet_ids

    security_group_ids = [
      data.terraform_remote_state.foundation.outputs.eks_security_group_id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = var.cluster_name
  }
}