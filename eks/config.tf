# Backend setup
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "terraform-eks-01"
    key    = "eks-terraformtfstate"
    region = "us-east-1"
  }
}

# Cloud provider
provider "aws" {
  region = var.region
}
