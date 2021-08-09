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

variable "prefix" {
  description = "Prefix for specific project/application infrastructure."
  default     = "upgrad"
}

variable "endpoint_public_access" {
  description = "Enable Public access"
  default     = true
}

variable "endpoint_private_access" {
  description = "Enable private access"
  default     = true
}

variable "max_size" {
  description = "Maximum size of nodegroup"
  default     = 1
}

variable "min_size" {
  description = "Minimum size of nodegroup"
  default     = 1
}

variable "desired_size" {
  description = "Desized Size of nodegroup"
  default     = 1
}