module "vpc" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/common/vpc"
  VPC_CIDR = var.VPC_CIDR
  ENV = var.ENV
  PUBLIC_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
}

output "az" {
  value = module.vpc.value[0]
}