# Launch Template for wordpress
resource "aws_launch_template" "wordpress_launch_template" {
  image_id               = var.web_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.web_sg
  key_name               = var.keypair

  iam_instance_profile {
    name = var.instance_profile
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
        Name = "${var.name}-Wordpress-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/wordpress.sh")
}

# launch template for toooling
resource "aws_launch_template" "tooling_launch_template" {
  image_id               = var.web_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.web_sg
  key_name               = var.keypair

  iam_instance_profile {
    name = var.instance_profile
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
        Name = "${var.name}-Tooling-Launch-Template"
      },
    )

  }

  user_data = filebase64("${path.module}/tooling.sh")
}
