output "vpc_identifier" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_main_cidr" {
  description = "Primary CIDR block of VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnet_list" {
  description = "Private subnets IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_list" {
  description = "Public subnets IDs"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ips" {
  description = "Elastic IPs for NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "availability_zones" {
  description = "AZs used in the deployment"
  value       = module.vpc.azs
}