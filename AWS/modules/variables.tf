variable "environment" {
    description = "Environment name"
    type        = string
}

variable "project_name" {
    description = "Project name"
    type        = string
}

variable "tags" {
    description = "Common tags for all resources"
    type        = map(string)
    default     = {}
}

variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}