variable "region" {
  default = "us-east-1"
}

variable "tags" {
  description = "Tags to propagate to all supported resources"
  type        = map(string)

  default = {
    Env        = "QA"
    managed-by = "Terraform"
  }
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC being deployed"
  default     = "EKS-vpc"
}

variable "vpc_ip_cidr" {
  type        = string
  description = "IP CIDR assigned to the environment"
  default     = "10.0.0.0/16"
}

variable "private_subnet_size" {
  default = 25
}

variable "public_subnet_size" {
  default = 25
}
