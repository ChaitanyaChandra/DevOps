module "asg" {
  source = "github.com/chaitanyachandra/devops/4.Terraform/modules/mutable/asg"
  min_size = var.min_size
  max_size = var.max_size
  app_port_no = var.app_port_no
  component_role = var.component_role
  APP_TYPE = var.APP_TYPE
  ENV = var.ENV
}