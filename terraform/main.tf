
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or specify the version you need
    }
  }
}

module "moses_vpc" {
    source = "./modules/vpc"

    providers = {
     aws = aws
    }
}




#module "moses_rds" {
#    source = "./modules/rds" # Path to your RDS module
  
#    providers = {
#      aws = aws
#    }
  
#    vpc_primary_db_subnet_group_name = module.moses_vpc.vpc_primary_db_subnet_group_name
#    vpc_secondary_db_subnet_group_name = module.moses_vpc.vpc_secondary_db_subnet_group_name
  
#    primary_db_security_group_id = module.moses_vpc.primary_db_security_group_id
#    secondary_db_security_group_id = module.moses_vpc.secondary_db_security_group_id
#}



module "my-eks" {
    source = "./modules/eks"

    providers = {
     aws = aws
    }

    vpc_cidr   = "10.0.0.0/16"
    
    # Correct references to outputs from the moses_vpc module
    vpc_primary_id                 = module.moses_vpc.vpc_primary_id
    vpc_secondary_id               = module.moses_vpc.vpc_secondary_id
    vpc_primary_private_subnets    = module.moses_vpc.vpc_primary_private_subnets
    vpc_secondary_private_subnets  = module.moses_vpc.vpc_secondary_private_subnets
} 




