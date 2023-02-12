resource "aws_security_group" "sg" {
  name        = "${var.env}-${var.name}-ec2.sg"
  description = "${var.env}-${var.name}-ec2.sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.BASTION_NODE]
  }

  ingress {
    description = "APP"
    from_port   = var.app_port_no
    to_port     = var.app_port_no
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-${var.name}-ec2.sg"
  }
}