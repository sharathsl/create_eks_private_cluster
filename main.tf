provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
   cluster_name = "petclinic-eks-${random_string.suffix.result}"
   cluster_name = "petclinic-eks"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = "petclinic-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/petclinic-eks" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/petclinic-eks" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = "petclinic-eks"
  cluster_version = "1.23"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    # two = {
    #   name = "node-group-2"

    #   instance_types = ["t3.small"]

    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    # }
  }
}

# module "efs_csi_driver" {
#   #source = "git::https://github.com/DNXLabs/terraform-aws-eks-efs-csi-driver.git"
#   source = "git::https://github.com/sharathsl/efs-csi-driver.git"

#   cluster_name                     = module.eks.cluster_id
#   cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
#   cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
# }

# provider "kubectl" {
#   config_path            = "~/.kube/config"
#   host                   = module.eks.cluster.endpoint
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority.0.data)
#   token                  = module.eks_auth.cluster.token
#   load_config_file       = false
# }

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#     host                   = module.eks.cluster.endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster.certificate_authority.0.data)
#     token                  = module.eks.cluster.token
#     load_config_file       = false
#   }
# }
