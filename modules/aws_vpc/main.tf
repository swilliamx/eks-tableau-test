data "aws_availability_zones" "available_az" {
}

locals {
  public_cidr      = cidrsubnet(var.vpc_cidr, 1, 0)
  private_cidr     = cidrsubnet(var.vpc_cidr, 1, 1)
  private_bit_diff = var.private_subnet_size - element(split("/", local.private_cidr), 1)
  public_bit_diff  = var.public_subnet_size - element(split("/", local.public_cidr), 1)
}

# VPC resource.
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      "Name" = var.vpc_name
    },
  )
}

# Default Security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress  {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# module for internet gateway creation.
module "aws_internet_gateway" {
  source = "../aws_igw/"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}-igw"
    },
  )
  vpc_id = aws_vpc.vpc.id
}

# Public subnet creation.
resource "aws_subnet" "public_subnets" {
  count                    = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  vpc_id                   = aws_vpc.vpc.id
  map_public_ip_on_launch  = true
  cidr_block               = cidrsubnet(local.public_cidr, local.public_bit_diff, count.index)
  availability_zone        = data.aws_availability_zones.available_az.names[count.index]

  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}-public-${count.index + 1}"
    },
  )
}

resource "aws_subnet" "private_subnets" {
  count             = var.az_count * (var.enable_private_subnets == "true" ? 1 : 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.private_cidr, local.private_bit_diff, count.index)
  availability_zone = data.aws_availability_zones.available_az.names[count.index]

  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}-private-${count.index + 1}"
    },
  )
}

# Route table creation.
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
  count  = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}-public-rt-${count.index + 1}"
    },
  )
}

# Internet gateway association with public route table.
resource "aws_route" "public_igw" {
  count                  = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  route_table_id         = element(aws_route_table.public_route.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.aws_internet_gateway.igw_id
}

# Public subnets assocation with route tables.
resource "aws_route_table_association" "public_route_assoc" {
  count          = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.public_route.*.id, count.index)
}

# Private subnets assocation with route tables.
resource "aws_route_table_association" "private_route_assoc" {
  count          = var.az_count * (var.enable_private_subnets == "true" ? 1 : 0)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}

# Private subnets route table creation
resource "aws_route_table" "private_route" {
  count  = var.az_count * (var.enable_private_subnets == "true" ? 1 : 0)
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      "Name" = "${var.vpc_name}-private-rt-${count.index + 1}"
    },
  )
}

# Module for EIP creation.
module "aws_eip" {
  source    = "../aws_eip/"
  eip_count = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  tags = merge(
    var.tags,
    {
      "Name" = var.vpc_name
    },
  )
}

# Nat Gateway creation for private subnet.
resource "aws_nat_gateway" "ngw" {
  count         = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  allocation_id = element(module.aws_eip.eip_alloc_id, count.index)
  tags = merge(
    var.tags,
    {
      "Name" = var.vpc_name
    },
  )
}

# Nat gateway association with private route table.
resource "aws_route" "private_nat_gateway" {
  count                  = var.az_count * (var.enable_public_subnets == "true" ? 1 : 0)
  route_table_id         = element(aws_route_table.private_route.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)
}
