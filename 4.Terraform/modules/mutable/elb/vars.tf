locals {
  #  env         = trimprefix("${var.TFC_WORKSPACE_NAME}", "chaitu-")
  env         = var.ENV
  remove_vpc_key = "state/${var.ENV}/vpc-terraform.tfstate"
  type = var.internal ? "private" : "public"

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
    "appenv" = "${local.env}"
  }
}

#variable "TFC_WORKSPACE_NAME" {
#  sensitive   = true
#  type        = string
#  default     = "chaitu-dev"
#  description = "WORKSPACE NAME imported from tfe"
#}

variable "ENV" {}
variable "internal" {}