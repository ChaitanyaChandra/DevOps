bucket         = "chaitanya-terraform-state-backend"
key            = "state/dev/mutable/mutable.terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-lock"