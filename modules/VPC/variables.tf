variable "region" {
  description = "Default aws region for this project"
}

variable "vpc_cidr" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  type = number
}

variable "preferred_number_of_private_subnets" {
  type = number
}

variable "private_subnets_cidrs" {
  type        = list(any)
  description = "List of private subnet cidrs"
}

variable "public_subnets_cidrs" {
  type        = list(any)
  description = "list of public subnets cidrs"
}

variable "name" {
  type = string
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
