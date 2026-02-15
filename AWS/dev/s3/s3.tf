data "aws_default_tags" "default" {}
  
data "aws_region" "current" {}


module "app_bucket" {
  source      = "./modules/s3"
  bucket_name = "my-enterprise-app-bucket"
  environment = "prod"

  enable_cloudfront_cache = true
  enable_versioning       = true
  enable_encryption       = true
  enable_logging          = true

  logging_bucket = "centralized-logs-bucket"

  lifecycle_rules = [
    {
      id     = "archive-old-objects"
      status = "Enabled"
      transitions = [
        { days = 30, storage_class = "STANDARD_IA" },
        { days = 90, storage_class = "GLACIER" }
      ]
      expiration = [
        { days = 365 }
      ]
    }
  ]
}