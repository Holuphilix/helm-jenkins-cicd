variable "repository_name" {
  type        = string
  description = "The name of the ECR repository"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}
