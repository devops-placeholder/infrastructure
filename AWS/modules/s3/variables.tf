############################################
# variables.tf
############################################

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

# Feature toggles
variable "enable_versioning" {
  type    = bool
  default = true
}

variable "enable_encryption" {
  type    = bool
  default = true
}

variable "enable_lifecycle" {
  type    = bool
  default = false
}

variable "enable_logging" {
  type    = bool
  default = false
}

variable "enable_cloudfront_cache" {
  description = "Enable CloudFront distribution for caching"
  type        = bool
  default     = false
}

variable "enable_public_access" {
  description = "Allow public access (NOT recommended for prod)"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle configuration rules"
  type        = any
  default     = []
}

variable "logging_bucket" {
  description = "Target bucket for access logs"
  type        = string
  default     = null
}