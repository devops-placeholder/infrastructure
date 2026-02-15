############################################
# outputs.tf
############################################

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "cloudfront_domain" {
  value       = var.enable_cloudfront_cache ? aws_cloudfront_distribution.this[0].domain_name : null
  description = "CloudFront distribution domain name"
}