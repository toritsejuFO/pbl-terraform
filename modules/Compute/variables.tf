variable "compute_subnets" {
  description = "public subnetes for compute instances"
}

variable "jenkins_ami" {
  type        = string
  description = "ami for jenkins"
}

variable "jfrog_ami" {
  type        = string
  description = "ami for jfrob"
}

variable "sonar_ami" {
  type        = string
  description = "ami for sonar"
}

variable "compute_sg" {
  description = "security group for compute instances"
}

variable "keypair" {
  type        = string
  description = "keypair for instances"
}

variable "name" {
  type = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
