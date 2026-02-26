############################################
# Provider
############################################

provider "aws" {
  region = var.region
}

############################################
# Availability Zones
############################################

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

############################################
# Locals
############################################

locals {
  cluster_name = "myapp-eks-cluster"
}

############################################
# VPC
############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "neyo-vpc"
  cidr = "10.0.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = {
    Environment = "development"
    Terraform   = "true"
  }
}

############################################
# EKS Cluster
############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  enable_irsa = true

  ############################################
  # Managed Node Groups Defaults
  ############################################

  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64"
    instance_types = ["t3.medium"]
    disk_size      = 20
  }

  ############################################
  # Managed Node Groups
  ############################################

  eks_managed_node_groups = {

    node-group-1 = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    node-group-2 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  ############################################
  # Tags
  ############################################

  tags = {
    Environment = "development"
    Terraform   = "true"
  }
}
