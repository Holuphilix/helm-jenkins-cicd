variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "jenkins-key"
}

variable "allowed_cidrs" {
  description = "CIDRs allowed for security group inbound"
  type        = list(string)
  default     = ["78.135.30.254/32"]
}

variable "node_desired_capacity" {
  description = "Desired EKS worker node count"
  type        = number
  default     = 2
}

variable "node_min_capacity" {
  description = "Minimum EKS worker node count"
  type        = number
  default     = 1
}

variable "node_max_capacity" {
  description = "Maximum EKS worker node count"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "List of EC2 instance types for EKS workers"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}
