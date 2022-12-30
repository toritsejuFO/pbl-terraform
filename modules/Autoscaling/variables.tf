# AMIs
variable "bastion_ami" {
  type        = string
  description = "ami for bastion"
}

variable "nginx_ami" {
  type        = string
  description = "ami for nginx"
}

variable "web_ami" {
  type        = string
  description = "ami for webservers"
}

# Security Groups
variable "bastion_sg" {
  type        = list(any)
  description = "security group for bastion"
}

variable "nginx_sg" {
  type        = list(any)
  description = "security group for nginx"
}

variable "web_sg" {
  type        = list(any)
  description = "security group for webservers"
}

# Subnets
variable "private_subnets" {
  type        = list(any)
  description = "first private subnets for internal ALB"
}

variable "public_subnets" {
  type        = list(any)
  description = "Seconf subnet for ecternal ALB"
}

# ARNs
variable "nginx_lb_tg" {
  type        = string
  description = "nginx reverse proxy target group"
}

variable "wordpress_lb_tg" {
  type        = string
  description = "wordpress target group"
}

variable "tooling_lb_tg" {
  type        = string
  description = "tooling target group"
}


# ASG
variable "max_size" {
  type        = number
  description = "maximum number for autoscaling"
}

variable "min_size" {
  type        = number
  description = "minimum number for autoscaling"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instance in autoscaling group"
}


variable "instance_profile" {
  type        = string
  description = "Instance profile for launch template"
}

variable "keypair" {
  type        = string
  description = "Keypair for instances"
}

variable "name" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
