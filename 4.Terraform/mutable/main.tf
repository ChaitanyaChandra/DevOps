module "nodejs" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/mutable/asg"
  min_size = var.min_size
  max_size = var.max_size
  app_port_no = 8080
  component_role = "backend_nodejs"
  APP_TYPE = "backend"
  ENV = var.ENV
  APP_VERSION = var.APP_VERSION
  APP_TYPE = "backend"
}

module "nginx" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/mutable/asg"
  min_size = var.min_size
  max_size = var.max_size
  app_port_no = 80
  component_role = "frontend"
  APP_TYPE = "frontend"
  ENV = var.ENV
  APP_VERSION = var.APP_VERSION
  APP_TYPE = "frontend"
}