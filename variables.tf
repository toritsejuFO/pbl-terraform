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
  description = "AWS Account ID to bill for resources"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "all_dest" {
  description = "cidr notation for all destination addresses"
  default = "0.0.0.0/0"
}
