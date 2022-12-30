variable "vpc_id" {
  type        = string
  description = "the vpc id"
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
