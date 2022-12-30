# Autoscaling for wordpress application
resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "wordpress-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnets

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.name}-Wordpress-ASG"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  lb_target_group_arn    = var.wordpress_lb_tg
}

# Autoscaling for tooling
resource "aws_autoscaling_group" "tooling_asg" {
  name                      = "tooling-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.tooling_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-Tooling-ASG"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling_asg.id
  lb_target_group_arn    = var.tooling_lb_tg
}
