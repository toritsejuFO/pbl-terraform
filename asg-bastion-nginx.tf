# Create sns topic for all the auto scaling groups
resource "aws_sns_topic" "pbl_sns" {
  name = "pbl-sns"
}

resource "aws_autoscaling_notification" "pbl_notifications" {
  group_names = [
    aws_autoscaling_group.bastion_asg.name,
    aws_autoscaling_group.nginx_asg.name,
    aws_autoscaling_group.wordpress_asg.name,
    aws_autoscaling_group.tooling_asg.name,
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.pbl_sns.arn
}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}

resource "aws_launch_template" "bastion_launch_template" {
  image_id               = var.bastion_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
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
      local.tags,
      {
        Name = "${var.Name}-Bastion-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

# Autoscaling for bastion  hosts
resource "aws_autoscaling_group" "bastion_asg" {
  name                      = "bastion-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  launch_template {
    id      = aws_launch_template.bastion_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.Name}-Bastion-ASG"
    propagate_at_launch = true
  }

}

# launch template for nginx

resource "aws_launch_template" "nginx_launch_template" {
  image_id               = var.nginx_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
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
      local.tags,
      {
        Name = "${var.Name}-Nginx-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/nginx.sh")
}

# Autoscaling group for reverse proxy nginx
resource "aws_autoscaling_group" "nginx_asg" {
  name                      = "nginx-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  launch_template {
    id      = aws_launch_template.nginx_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.Name}-Nginx-ASG"
    propagate_at_launch = true
  }

}

# Attach Autoscaling Group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.id
  lb_target_group_arn   = aws_lb_target_group.nginx_tg.arn
}
