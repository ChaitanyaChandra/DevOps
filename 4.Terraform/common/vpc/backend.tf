terraform {
  backend "s3" {}
}

data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket         = "chaitanya-terraform-state-backend"
    key            = "state/${var.ENV}/vpc-terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}