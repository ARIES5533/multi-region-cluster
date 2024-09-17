
#########Create primary VPC in the eu-west-1 region#####################
module "vpc_primary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  providers = {
    aws = aws
  }

  name = "olumoko-primary-vpc"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.eu-west-1.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  
  enable_dns_hostnames = true
  enable_nat_gateway = true
  create_igw = true 

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

output "vpc_primary_id" {
  description = "The ID of the primary VPC in us-west-1"
  value       = module.vpc_primary.vpc_id
}

output "vpc_primary_public_subnets" {
  description = "The public subnet IDs of the primary VPC in us-west-1"
  value       = module.vpc_primary.public_subnets
}

output "vpc_primary_private_subnets" {
  description = "The private subnet IDs of the primary VPC in us-west-1"
  value       = module.vpc_primary.private_subnets
}


################################################################################



############Create secondary VPC in another region (eu-west-1)##################
module "vpc_secondary" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  providers = {
    aws = aws.us-west-2
  }

  name = "olumoko-secondary-vpc"
  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.us-west-2.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  
  enable_dns_hostnames = true
  enable_nat_gateway = true
  create_igw = true 

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}


output "vpc_secondary_id" {
  description = "The ID of the secondary VPC in eu-west-1"
  value       = module.vpc_secondary.vpc_id
}

output "vpc_secondary_public_subnets" {
  description = "The public subnet IDs of the secondary VPC in eu-west-1"
  value       = module.vpc_secondary.public_subnets
}

output "vpc_secondary_private_subnets" {
  description = "The private subnet IDs of the secondary VPC in eu-west-1"
  value       = module.vpc_secondary.private_subnets
}


##############################################################################


##########Define the primary RDS subnet group in the eu-west-1 region#########
resource "aws_db_subnet_group" "primary" {
  name        = "primary-db-subnet-group"
  provider    = aws.eu-west-1
  description = "Subnet group for primary RDS instance in us-west-1"
  subnet_ids  = module.vpc_primary.private_subnets

  tags = {
    Name = "Olumoko-Primary-DB-Subnet-Group"
  }
}


output "vpc_primary_db_subnet_group_name" {
  description = "The name of the primary database subnet group."
  value       = aws_db_subnet_group.primary.name
}

output "vpc_primary_db_subnet_group_id" {
  description = "The name of the primary database subnet group."
  value       = aws_db_subnet_group.primary.id
}

#######################################################################################


#############Define the secondary RDS subnet group in the us-west-2 region#############
resource "aws_db_subnet_group" "secondary" {
  provider    = aws.us-west-2
  name        = "secondary-db-subnet-group"
  description = "Subnet group for secondary RDS instance in eu-west-1"
  subnet_ids  = module.vpc_secondary.private_subnets

  tags = {
    Name = "Olumoko-Secondary-DB-Subnet-Group"
  }
}

output "vpc_secondary_db_subnet_group_name" {
  description = "The name of the secondary database subnet group."
  value       = aws_db_subnet_group.secondary.name
}

output "vpc_secondary_db_subnet_group_id" {
  description = "The name of the secondary database subnet group."
  value       = aws_db_subnet_group.secondary.id
}

#############################################################