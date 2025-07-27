provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr

  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2

  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2

  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

module "security_group" {
  source         = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
  allowed_cidrs  = var.allowed_cidrs
}

module "keypair" {
  source   = "./modules/keypair"
  key_name = var.key_name
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]  # ✅ Get first public subnet ID
  security_group_id  = module.security_group.security_group_id
  key_name           = module.keypair.key_name
  user_data_path     = "${path.root}/../jenkins-setup/user_data.sh"
  environment        = var.environment
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "jenkins-cicd-app"
  environment     = var.environment
}

module "eks" {
  source                = "./modules/eks"
  cluster_name          = "helm-eks-cluster"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnet_ids  # ✅ Must match the outputs.tf in vpc module
  node_instance_type    = "t3.medium"
  eks_security_group_id = module.security_group.security_group_id  # ✅ Optional override

  cluster_role_arn      = module.iam.eks_cluster_role_arn
  node_role_arn         = module.iam.eks_node_role_arn
}

module "iam" {
  source    = "./modules/iam"
  role_name = "jenkins-eks-role"
}
