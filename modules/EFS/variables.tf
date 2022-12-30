variable "efs_subnets" {
  type        = list(any)
  description = "List of subnet ids for the mount target"
}

variable "efs_sg" {
  type        = list(any)
  description = "List of security group ids for the file system"

}

variable "billingAccount" {
  type        = string
  description = "account number for the aws"
}

variable "name" {
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
