locals {
  #  env         = trimprefix("${var.TFC_WORKSPACE_NAME}", "chaitu-")
  env         = var.ENV
  remove_vpc_key = "state/${var.ENV}/vpc-terraform.tfstate"
  Environment = local.env == "dr" || local.env == "prod" ? "prod" : "nonpord"
  region = "us-east-1"
  #  region      = local.env == "dr" || local.env == "prod" ? "us-east-2" : "us-east-1"
  tags = {
    "Environment"  = local.Environment
    "region"       = local.region
    "Service"      = "chaitu"
    "SupportGroup" = "Managed Services L2"
  }
  env_tag = {
    "appenv" = "${local.env}-app"
  }
}

#variable "TFC_WORKSPACE_NAME" {
#  sensitive   = true
#  type        = string
#  default     = "chaitu-dev"
#  description = "WORKSPACE NAME imported from tfe"
#}
variable "min_size" {}
variable "max_size" {}
variable "app_port_no" {}
variable "component_role" {}
variable "component" {}
variable "APP_TYPE" {}
variable "ENV" {}
variable "APP_VERSION" {
  type = string
}
variable "lb_arn" {}
variable "ROLE_AUGMENTS" {
  default = " "
}