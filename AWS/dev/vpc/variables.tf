variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "enable_site_to_site_vpn" {
  description = "Enable site-to-site VPN"
  type        = bool
}

variable "customer_gateway_ip" {
  description = "Customer gateway IP address"
  type        = string
}

variable "onprem_cidr" {
  description = "On-premises CIDR block"
  type        = string
}
