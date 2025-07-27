aws_region          = "us-east-1"
environment         = "dev"

vpc_name            = "helm-jenkins-cicd-vpc"
vpc_cidr            = "10.0.0.0/16"

# Updated to include two public subnets
public_subnet_cidr_1  = "10.0.1.0/24"
public_subnet_cidr_2  = "10.0.2.0/24"

private_subnet_cidr_1 = "10.0.3.0/24"
private_subnet_cidr_2 = "10.0.4.0/24"

availability_zone_1   = "us-east-1a"
availability_zone_2   = "us-east-1b"

ami_id              = "ami-020cba7c55df1f615"
instance_type       = "t3.medium"
key_name            = "jenkins-key"
allowed_cidrs       = ["78.135.30.254/32"]

node_desired_capacity = 2
node_min_capacity     = 1
node_max_capacity     = 3
node_instance_types   = ["t3.medium"]

project_name        = "helm-jenkins-cicd"

