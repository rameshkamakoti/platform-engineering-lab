locals {

  backend_bucket_name = "${var.project_name}-${data.aws_caller_identity.current.account_id}-tfstate"

  lock_table_name = "${var.project_name}-terraform-lock"

  common_tags = {

    Project = var.project_name

    Environment = var.environment

    ManagedBy = "Terraform"

    Owner = "Platform Engineering"

    Repository = "platform-engineering-lab"

  }

}