# Launch Template for wordpress
resource "aws_launch_template" "wordpress_launch_template" {
  image_id               = var.webserver_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name               = var.keypair

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.id
  }

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "${var.Name}-Wordpress-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/wordpress.sh")
}

# Autoscaling for wordpress application
resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "wordpress-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [

    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.Name}-Wordpress-ASG"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  lb_target_group_arn   = aws_lb_target_group.wordpress_tg.arn
}

# launch template for toooling
resource "aws_launch_template" "tooling_launch_template" {
  image_id               = var.webserver_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name = var.keypair

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.id
  }

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "${var.Name}-Tooling-Launch-Template"
      },
    )

  }

  user_data = filebase64("${path.module}/tooling.sh")
}

# Autoscaling for tooling

resource "aws_autoscaling_group" "tooling_asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [

    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  launch_template {
    id      = aws_launch_template.tooling_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.Name}-Tooling-ASG"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling_asg.id
  lb_target_group_arn   = aws_lb_target_group.tooling_tg.arn
}
