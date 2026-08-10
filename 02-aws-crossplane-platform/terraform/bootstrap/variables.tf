variable "aws_region" {
  description = "AWS region for platform resources"

  type = string

  default = "us-east-2"
}

variable "project_name" {
  description = "Project name"

  type = string

  default = "platform-engineering-lab"
}

variable "environment" {
  description = "Environment"

  type = string

  default = "bootstrap"
}

variable "vpc_cidr" {
  description = "VPC CIDR"

  type = string

  default = "10.0.0.0/16"
}

variable "availability_zones" {

  type = list(string)

  default = [
    "us-east-2a",
    "us-east-2b"
  ]
}