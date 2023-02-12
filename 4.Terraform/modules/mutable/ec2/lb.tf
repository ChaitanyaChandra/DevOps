resource "aws_lb_target_group" "main" {
  name     = "${var.env}-${var.name}-tg"
  port     = var.app_port_no
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 6
    port                = var.app_port_no
    path                = "/"
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = var.LB_TYPE == "public" ? data.terraform_remote_state.alb.outputs.PUBLIC_LB_ARN : data.terraform_remote_state.alb.outputs.PRIVATE_LB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#resource "aws_lb_listener_rule" "rule" {
#  count        = var.type == "backend" ? 1 : 0
#  listener_arn = var.alb["private"].lb_listener_arn
#  priority     = var.lb_listener_priority
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.main.arn
#  }
#
#  condition {
#    host_header {
#      values = ["${var.name}-${var.env}.chaitu.net"]
#    }
#  }
#
#}
#
#resource "aws_lb_listener" "public-https" {
#  count             = var.type == "frontend" ? 1 : 0
#  load_balancer_arn = var.alb["public"].lb_arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = var.ACM_ARN
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.main.arn
#  }
#}