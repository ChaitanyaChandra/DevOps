resource "aws_lb" "main" {
  name               = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-${local.type}-lb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.internal ? data.terraform_remote_state.remote_vpc.outputs.private_subnets : data.terraform_remote_state.remote_vpc.outputs.public_subnets

  tags = {
    Name = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-${local.type}-alb"
  }
}

resource "aws_security_group" "main" {
  name        = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-${local.type}-alb.sg"
  description = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-${local.type}-alb.sg"
  vpc_id      = data.terraform_remote_state.remote_vpc.outputs.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.internal ? [data.terraform_remote_state.remote_vpc.outputs.vpc_id] : ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.internal ? [data.terraform_remote_state.remote_vpc.outputs.vpc_id] : ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-${local.type}-alb.sg"
  }
}

resource "aws_lb_listener" "main" {
  count             = var.internal ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "public-http" {
  count             = var.internal ? 0 : 1
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


