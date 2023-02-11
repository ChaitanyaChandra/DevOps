locals {
  env         = trimprefix("${var.TFC_WORKSPACE_NAME}", "chaitu-")
  Environment = local.env == "dr" || local.env == "prod" ? "prod" : "nonpord"
  region = "us-east-1"
#   region      = local.env == "dr" || local.env == "prod" ? "us-west-2" : "us-east-1"
  tags = {
    "Environment"  = local.Environment
    "region"       = local.region
    "Service"      = "chaitu"
    "SupportGroup" = "Managed Services L2"
  }
  env_tag = {
    "appenv" = local.env
  }
}

variable "TFC_WORKSPACE_NAME" {
  sensitive   = true
  type        = string
  default     = "chaitu-dev"
  description = "WORKSPACE NAME imported from tfe"
}

variable "domain" {
  type    = string
  default = "chaitu.net"
}

variable "dd" {
  default = <<EOF
ewogICJBUFBfVVNFUiIgOiAiYWRtaW4iLAogICJBUFBfUEFTUyIgOiAiQDEyM0NoYWl0dSIsCiAg
IkREX0FQSV9LRVkiIDogIjFmZTA2NTUxZjM1Y2NmN2NmMjI1ZmE5YmZiOTVkNWYxIgp9Cg==
EOF
}