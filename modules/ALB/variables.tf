# The security froup for external loadbalancer
variable "public_sg" {
  description = "Security group for external load balancer"
}


# The public subnet froup for external loadbalancer
variable "public_subnets" {
  description = "List of public subnet ids to deploy external ALB"
}


variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}


variable "private_sg" {
  description = "Security group for Internal Load Balance"
}

variable "private_subnets" {
  description = "List of private subnet ids to deploy Internal ALB"
}

variable "ip_address_type" {
  type        = string
  description = "IP address for the ALB"

}

variable "load_balancer_type" {
  type        = string
  description = "te type of Load Balancer"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}


variable "name" {
  type        = string
  description = "name of the loadbalancer"
}
