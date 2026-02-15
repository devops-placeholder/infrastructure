############################################
# variables.tf
############################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
}

variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

# VPN feature toggle
variable "enable_site_to_site_vpn" {
  description = "Enable Site‑to‑Site VPN integration"
  type        = bool
  default     = false
}

variable "onprem_cidr" {
  description = "On‑premises CIDR block"
  type        = string
  default     = null
}

variable "customer_gateway_ip" {
  description = "Public IP of on‑prem customer gateway"
  type        = string
  default     = null
}

variable "bgp_asn" {
  description = "BGP ASN for customer gateway"
  type        = number
  default     = 65000
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}