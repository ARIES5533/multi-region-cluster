
locals {
  cluster_name = "olumoko-project"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"
  create_iam_role = true
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

      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }

}


##############################################################


module "eks-secondary" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"
  


  providers = {
    aws = aws.us-west-2
  }

  cluster_name    = local.cluster_name
  cluster_version = "1.24"
  create_iam_role = true
  enable_irsa     = true

  vpc_id                         = var.vpc_secondary_id
  subnet_ids                     = var.vpc_secondary_private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }  
}



#######################################

resource "aws_iam_policy" "autoscaler_policy" {
  name        = "EKSClusterAutoscalerPolicy"
  description = "Policy to allow EKS Cluster Autoscaler to interact with AWS APIs"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource" : "*"
      }
    ]
  })
}

#########

# Attach IAM Policy to Worker Nodes - Primary Cluster
resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attach_primary" {
  role       = module.eks.eks_managed_node_groups["one"].iam_role_name
  policy_arn = aws_iam_policy.autoscaler_policy.arn
}

# Attach IAM Policy to Worker Nodes - Secondary Cluster
resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attach_secondary" {
  role       = module.eks-secondary.eks_managed_node_groups["one"].iam_role_name
  policy_arn = aws_iam_policy.autoscaler_policy.arn
}

