module "vpc" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/common/vpc"
}

output "value" {
  value = module.vpc.running
}