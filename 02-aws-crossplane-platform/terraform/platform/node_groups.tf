resource "aws_eks_node_group" "platform" {
  cluster_name    = aws_eks_cluster.platform.name
  node_group_name = "platform-node-group"
  node_role_arn   = data.terraform_remote_state.foundation.outputs.eks_node_role_arn

  subnet_ids = data.terraform_remote_state.foundation.outputs.private_app_subnet_ids

  instance_types = ["t3.small"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role        = "application"
    environment = var.environment
  }

  tags = {
    Name = "platform-node-group"
  }
}