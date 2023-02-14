resource "aws_lb_target_group" "main" {
  name     = "${local.tags.Service}-${local.Environment}-${var.component}-tg"
  port     = var.app_port_no
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.remote_vpc.outputs.vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 6
    port                = var.app_port_no
    path                = var.APP_TYPE == "backend" ? "/health" : "/status"
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = var.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}