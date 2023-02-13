module "asg" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/mutable/asg"
  VPC_CIDR = var.VPC_CIDR
  ENV = var.ENV
  PUBLIC_SUBNET_CIDR = var.PUBLIC_SUBNET_CIDR
  PRIVATE_SUBNET_CIDR = var.PRIVATE_SUBNET_CIDR
}