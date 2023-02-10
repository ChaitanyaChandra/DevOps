terraform {
  backend "s3" {
    bucket         = "chaitanya-terraform-state-backend"
    key            = "state/apps/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}