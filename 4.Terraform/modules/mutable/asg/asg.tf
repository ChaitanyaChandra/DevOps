resource "aws_launch_template" "launch-template" {
  name                   = "${local.tags.Service}-${local.Environment}-${var.component_role}-${local.env_tag.appenv}-lt"
  image_id               = "ami-07acf41a58c76cc08"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = data.terraform_remote_state.bastian_host_and_apps.outputs.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  instance_market_options {
    market_type = "spot"
  }


  user_data = base64encode(templatefile("${path.module}/templates/code.sh", {
    COMPONENT_ROLE = var.component_role
    APP_VERSION = var.APP_VERSION
    ENV       = var.ENV
    ROLE_AUGMENTS = var.ROLE_AUGMENTS
  }))
}


resource "aws_autoscaling_group" "asg" {
  name                = "${local.tags.Service}-${local.Environment}-${var.component_role}-${local.env_tag.appenv}-asg"
  desired_capacity    = var.min_size
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.APP_TYPE == "backend" ? data.terraform_remote_state.remote_vpc.outputs.private_subnets : data.terraform_remote_state.remote_vpc.outputs.public_subnets
  target_group_arns   = [aws_lb_target_group.main.arn]

  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.tags.Service}-${local.Environment}-${var.component_role}-${local.env_tag.appenv}-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu-tracking-policy" {
  name        = "whenCPULoadIncrease"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  autoscaling_group_name = aws_autoscaling_group.asg.name
}