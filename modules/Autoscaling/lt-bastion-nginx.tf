resource "aws_launch_template" "bastion_launch_template" {
  image_id               = var.bastion_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.bastion_sg
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
        Name = "${var.name}-Bastion-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

resource "aws_launch_template" "nginx_launch_template" {
  image_id               = var.nginx_ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.nginx_sg
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
        Name = "${var.name}-Nginx-Launch-Template"
      },
    )
  }

  user_data = filebase64("${path.module}/nginx.sh")
}
