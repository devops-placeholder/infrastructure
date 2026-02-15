############################################
# main.tf
############################################

resource "aws_s3_bucket" "aws_s3" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name        = var.bucket_name
    Environment = var.environment
  })
}

############################################
# Versioning
############################################

resource "aws_s3_bucket_versioning" "aws_s3" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.aws_s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

############################################
# Encryption
############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "aws_s3" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.aws_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

############################################
# Public Access Block
############################################

resource "aws_s3_bucket_public_access_block" "aws_s3" {
  bucket = aws_s3_bucket.aws_s3.id

  block_public_acls       = !var.enable_public_access
  block_public_policy     = !var.enable_public_access
  ignore_public_acls      = !var.enable_public_access
  restrict_public_buckets = !var.enable_public_access
}

############################################
# Logging
############################################

resource "aws_s3_bucket_logging" "aws_s3" {
  count = var.enable_logging && var.logging_bucket != null ? 1 : 0

  bucket        = aws_s3_bucket.aws_s3.id
  target_bucket = var.logging_bucket
  target_prefix = "${var.bucket_name}/"
}

############################################
# Lifecycle
############################################

resource "aws_s3_bucket_lifecycle_configuration" "aws_s3" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.aws_s3.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", [])
        content {
          days = expiration.value.days
        }
      }
    }
  }
}

############################################
# CloudFront (Optional Caching Layer)
############################################

resource "aws_cloudfront_origin_access_control" "aws_s3" {
  count = var.enable_cloudfront_cache ? 1 : 0

  name                              = "${var.bucket_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "aws_s3" {
  count = var.enable_cloudfront_cache ? 1 : 0

  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.aws_s3.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.aws_s3[0].id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
