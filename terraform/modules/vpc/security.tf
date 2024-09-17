
##############Create VPC in primary region (us-east-1)#######################
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"


  name = "olumoko-sg-1"
  description = "Security group"
  vpc_id = module.vpc_primary.vpc_id

    ingress_with_cidr_blocks = [
      {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       description = "Allow outbound HTTPS traffic"
       cidr_blocks = "10.0.0.0/16"
      },
      {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       description = "Allow outbound HTTP traffic"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    egress_with_cidr_blocks = [
      {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       description = "Allow outbound HTTPS traffic"
       cidr_blocks = "0.0.0.0/0"
      },
      {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       description = "Allow outbound HTTP traffic"
       cidr_blocks = "0.0.0.0/0"
      }
    ]

    depends_on = [module.vpc_primary]

    tags = {
        name = "olumoko-sg-1"
    }
       
}

output "primary_sg_id" {
  description = "The ID of the primary security group in us-east-1"
  value       = module.security-group.security_group_id
}

######################################################################################

###############Create Security Group for secondary region DB (us-west-2)##############

module "secondary-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  providers = {
    aws = aws.us-west-2
  }


  name = "olumoko-sg-2"
  description = "Security group"
  vpc_id = module.vpc_secondary.vpc_id

    ingress_with_cidr_blocks = [
      {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       description = "Allow outbound HTTPS traffic"
       cidr_blocks = "10.0.0.0/16"
      },
      {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       description = "Allow outbound HTTP traffic"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    egress_with_cidr_blocks = [
      {
       from_port   = 443
       to_port     = 443
       protocol    = "tcp"
       description = "Allow outbound HTTPS traffic"
       cidr_blocks = "0.0.0.0/0"
      },
      {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       description = "Allow outbound HTTP traffic"
       cidr_blocks = "0.0.0.0/0"
      }
    ]

    depends_on = [module.vpc_secondary]

    tags = {
        name = "olumoko-sg-2"
    }
       
}


output "secondary_sg_id" {
  description = "The ID of the secondary security group in us-west-2"
  value       = module.secondary-security-group.security_group_id
}

#####################################################################################

##########Create Security Group for primary region DB (us-east-1)####################

module "primary-security-group_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  providers = {
    aws = aws
  }


  name = "olumoko-primary_sg-db"
  description = "Allow traffic on PostgreSQL port 5432"
  vpc_id = module.vpc_primary.vpc_id

    ingress_with_cidr_blocks = [
      {
       from_port   = 5432
       to_port     = 5432
       protocol    = "tcp"
       description = "Allow inbound traffic on PostgreSQL port 5432"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    egress_with_cidr_blocks = [
      {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       description = "Allow outbound traffic on PostgreSQL port 5432"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    depends_on = [module.vpc_primary]

    tags = {
        name = "olumoko-sg-db"
    }
       
}

output "primary_db_security_group_id" {
  description = "The ID of the RDS security group in us-east-1"
  value       = module.security-group.security_group_id
}

########################################################################################

###########Create Security Group for secondary region DB (us-west-2)####################


module "secondary-security-group_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  providers = {
    aws = aws.us-west-2
  }


  name = "olumoko-secondary_sg-db"
  description = "Allow traffic on PostgreSQL port 5432"
  vpc_id = module.vpc_secondary.vpc_id

    ingress_with_cidr_blocks = [
      {
       from_port   = 5432
       to_port     = 5432
       protocol    = "tcp"
       description = "Allow inbound traffic on PostgreSQL port 5432"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    egress_with_cidr_blocks = [
      {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       description = "Allow outbound traffic on PostgreSQL port 5432"
       cidr_blocks = "10.0.0.0/16"
      }
    ]

    depends_on = [module.vpc_secondary]

    tags = {
        name = "olumoko-sg-db"
    }
}


output "secondary_db_security_group_id" {
  description = "The ID of the RDS security group in us-west-2"
  value       = module.secondary-security-group_db.security_group_id
}

###################################################################################



