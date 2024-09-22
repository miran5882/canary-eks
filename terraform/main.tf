provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.24"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t2.small"]
    }
  }

  # Enable CloudWatch logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Handle existing KMS alias
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks.arn
  }
}

resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/eks/${var.cluster_name}"
  target_key_id = aws_kms_key.eks.key_id

  lifecycle {
    ignore_changes = [name]
  }
}

