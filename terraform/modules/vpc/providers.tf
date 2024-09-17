provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or specify the version you need
    }
  }
}


provider "aws" {
  alias = "eu-west-1"
  region = var.primary_region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  alias  = "us-west-2"
  region = var.secondary_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Define data sources for availability zones in each region
data "aws_availability_zones" "eu-west-1" {
  provider = aws.eu-west-1
  state    = "available"
}

data "aws_availability_zones" "us-west-2" {
  provider = aws.us-west-2
  state    = "available"
}

locals {
  cluster_name = "pip-olumoko-project"
}