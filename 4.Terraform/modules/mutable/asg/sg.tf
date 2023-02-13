resource "aws_security_group" "sg" {
  name        = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-ec2.sg"
  description = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-ec2.sg"
  vpc_id      = data.terraform_remote_state.remote_vpc.outputs.vpc_id


  ingress {
    description     = "allow all for bastian host and other CICD applications"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [data.terraform_remote_state.remote_vpc.outputs.vpc_cidr]
#     security_groups = [data.terraform_remote_state.bastian_host_and_apps.outputs.aws_sg_id]  # apps was in different vpc
  }

  ingress {
    description = "APP"
    from_port   = var.app_port_no
    to_port     = var.app_port_no
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.remote_vpc.outputs.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-ec2.sg"
  }
}