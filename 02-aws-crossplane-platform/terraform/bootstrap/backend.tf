terraform {
  backend "s3" {
    bucket       = "platform-engineering-lab-777929922779-tfstate"
    key          = "bootstrap/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}