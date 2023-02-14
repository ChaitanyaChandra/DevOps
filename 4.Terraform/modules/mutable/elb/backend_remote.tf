data "terraform_remote_state" "remote_vpc" {
  backend = "s3"
  config = {
    bucket         = "chaitanya-terraform-state-backend"
    key            = local.remove_vpc_key
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}


data "terraform_remote_state" "bastian_host_and_apps" {
  backend = "s3"
  config = {
    bucket         = "chaitanya-terraform-state-backend"
    key            = "state/apps/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
