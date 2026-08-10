locals {
  common_tags = {
    Project     = "platform-engineering-lab"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Platform Engineering"
    Repository  = "platform-engineering-lab"
  }
}