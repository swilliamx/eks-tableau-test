# Remote state for VPC
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-eks-01"
    key    = "vpc-eks"
    region = "us-east-1"
  }
}

# EKS cluster
resource "aws_eks_cluster" "dev-cluster" {
  name     = "${var.prefix}-dev-eks-cluster"
  role_arn = aws_iam_role.eksclusterrole.arn

  vpc_config {
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    security_group_ids      = [data.terraform_remote_state.vpc.outputs.default_security_group]
    subnet_ids              = [data.terraform_remote_state.vpc.outputs.private_subnets[0], data.terraform_remote_state.vpc.outputs.private_subnets[1], data.terraform_remote_state.vpc.outputs.public_subnets[0], data.terraform_remote_state.vpc.outputs.public_subnets[1]]
  }
  tags = var.tags
}

# Nodegroup
resource "aws_eks_node_group" "dev-cluster-nodegroup" {
  cluster_name    = aws_eks_cluster.dev-cluster.name
  node_group_name = "${var.prefix}-dev-eks-nodegroup"
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = [data.terraform_remote_state.vpc.outputs.private_subnets[0], data.terraform_remote_state.vpc.outputs.private_subnets[1], data.terraform_remote_state.vpc.outputs.public_subnets[0], data.terraform_remote_state.vpc.outputs.public_subnets[1]]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key               = "rds-key"
    source_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group]
  }
}