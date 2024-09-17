
locals {
  cluster_name = "pip-olumoko-project"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"
  enable_irsa     = true

  vpc_id                         = var.vpc_primary_id
  subnet_ids                     = var.vpc_primary_private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3a.xlarge"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3a.xlarge"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
}