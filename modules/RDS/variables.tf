variable "master_username" {
  type        = string
  description = "The master username"
}

variable "master_password" {
  type        = string
  description = "The master password"
}

variable "db_sg" {
  type        = list(any)
  description = "The list of DB security group"
}

variable "private_subnets" {
  type        = list(any)
  description = "List of private subnets ids for DB subnets group"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  type = string
}
