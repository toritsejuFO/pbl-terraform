variable "region" {
  description = "Default aws region for this project"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "preferred_number_of_public_subnets" {
  default = 2
}

variable "preferred_number_of_private_subnets" {
  default = 4
}

variable "Name" {
  default = "IAC"
}

variable "Environment" {
  default = "development"
}

variable "OwnerEmail" {
  default = "test@testmail.com"
}

variable "ManagedBy" {
  default = "Terraform"
}

variable "BillingAccount" {
  type        = number
  description = "AWS Account ID to bill for resources"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "all_dest" {
  description = "cidr notation for all destination addresses"
  default     = "0.0.0.0/0"
}

variable "bastion_ami" {
  type        = string
  description = "Bastion AMI ID for the the launch template"
}

variable "nginx_ami" {
  type        = string
  description = "Nginx AMI ID for the the launch template"
}

variable "webserver_ami" {
  type        = string
  description = "Webserver AMI ID for the the launch template"
}

variable "keypair" {
  type        = string
  description = "Key pair name for launch template instances"
}

variable "master_username" {
  type        = string
  description = "Admin username for RDS instance"
}

variable "master_password" {
  type        = string
  description = "Admin password for RDS instance"
}
