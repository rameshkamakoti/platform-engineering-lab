resource "aws_ecr_repository" "payment_api" {
  name                 = "payment-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "payment-api"
  }
}