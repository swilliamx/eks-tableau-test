output "vpc_id" {
  description = "VPC Id for application"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnets for application"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnets for application"
  value       = module.vpc.private_subnets
}

output "igw_id" {
  description = "Internet gateway for public subnets"
  value       = module.vpc.igw_id
}

output "public_routes" {
  description = "Public routes for public subnets"
  value       = module.vpc.public_routes
}

output "private_routes" {
  description = "Private routes for private subnets"
  value       = module.vpc.private_routes
}

output "nat_gateway_ids" {
  description = "Nat gateway ids for private subnets."
  value       = module.vpc.nat_gateway_ids
}

output "vpc_cidr" {
  description = "VPC cidr ranges for vpc created."
  value       = module.vpc.vpc_cidr
}

output "security_group" {
  description = "Security Group for ControlPlane."
  value       = aws_security_group.controlplane.id
}

output "default_security_group" {
  description = "Security Group for VPC."
  value       = module.vpc.default_group
}
