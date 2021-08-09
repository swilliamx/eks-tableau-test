# module for VPC creation.
module "vpc" {
  source              = "../modules/aws_vpc/"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_ip_cidr
  tags                = var.tags
  private_subnet_size = var.private_subnet_size
  public_subnet_size  = var.public_subnet_size
}

resource "aws_security_group" "controlplane" {
  name        = "${var.vpc_name}-ControlPlaneSecurityGroup"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}