# Create key from key management system
resource "aws_kms_key" "kms_key" {
  description = "KMS key "
  policy      = <<EOF
    {
    "Version": "2012-10-17",
    "Id": "kms-key-policy",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.BillingAccount}:user/terraform"
        },
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# Create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.kms_key.key_id
}

# Create Elastic file system
resource "aws_efs_file_system" "efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.kms_key.arn

  tags = merge(
    local.tags,
    {
      Name = "${var.Name}-efs"
    },
  )
}

# Set first mount target for the EFS 
resource "aws_efs_mount_target" "private_subnet_1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private[0].id
  security_groups = [aws_security_group.datalayer_sg.id]
}

# Set second mount target for the EFS 
resource "aws_efs_mount_target" "private_subnet_2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private[1].id
  security_groups = [aws_security_group.datalayer_sg.id]
}

# Create access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/wordpress"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }
  }
}

# Create access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/tooling"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }
  }
}
