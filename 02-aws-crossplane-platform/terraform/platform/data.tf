data "terraform_remote_state" "foundation" {
  backend = "s3"

  config = {
    bucket = "platform-engineering-lab-777929922779-tfstate"
    key    = "bootstrap/terraform.tfstate"
    region = "us-east-2"
  }
}