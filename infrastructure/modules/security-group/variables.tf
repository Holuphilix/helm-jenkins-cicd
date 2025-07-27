variable "vpc_id" {
  description = "VPC ID to associate with the security group"
  type        = string
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks to allow access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Update this for production
}

variable "environment" {
  description = "Project environment (e.g., dev, staging)"
  type        = string
}
