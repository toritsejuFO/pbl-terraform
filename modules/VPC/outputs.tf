output "public_subnet_1_id" {
  value       = aws_subnet.public[0].id
  description = "The first public subnet in the subnets"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public[1].id
  description = "The second public subnet"
}


output "private_subnet_1_id" {
  value       = aws_subnet.private[0].id
  description = "The first private subnet"
}

output "private_subnet_2_id" {
  value       = aws_subnet.private[1].id
  description = "The second private subnet"
}


output "private_subnet_3_id" {
  value       = aws_subnet.private[2].id
  description = "The third private subnet"
}


output "private_subnet_4_id" {
  value       = aws_subnet.private[3].id
  description = "The fourth private subnet"
}


output "vpc_id" {
  value = aws_vpc.main.id
}


output "instance_profile_id" {
  value = aws_iam_instance_profile.ec2_instance_profile.id
}
