# Enterprise Reusable Terraform S3 Module

## Overview
This module provisions a **secure, reusable, and enterprise‑grade Amazon S3 bucket** with optional capabilities enabled via **feature toggle booleans**.

It is designed for:
- Multi‑environment Terraform architectures (dev / stage / prod)
- Secure‑by‑default cloud governance
- Easy extensibility for enterprise workloads
- Integration with CloudFront, ECS, and application platforms

---

## Design Principles

### 1. Secure by Default
- Server‑side encryption enabled
- Versioning enabled
- Public access blocked
- Least‑privilege ready for CloudFront OAC

### 2. Feature Toggle Architecture
All optional capabilities are controlled using boolean flags such as:
- `enable_cloudfront_cache`
- `enable_logging`
- `enable_lifecycle`
- `enable_versioning`
- `enable_encryption`

This allows **one reusable module** across all environments instead of multiple forks.

### 3. Enterprise Compatibility
Built to integrate with:
- Centralized logging buckets
- CloudFront CDN layer
- Future KMS encryption & DR replication
- Terraform modular mono‑repo structures

---

## Module Structure

```
modules/s3/
 ├── variables.tf
 ├── main.tf
 ├── outputs.tf
 └── README.md
```

---

## Inputs

### Required
| Name | Description | Type |
|------|-------------|------|
| `bucket_name` | Name of the S3 bucket | `string` |
| `environment` | Environment name (dev/stage/prod) | `string` |

### Optional Feature Toggles
| Variable | Default | Description |
|----------|---------|-------------|
| `enable_versioning` | `true` | Enables object versioning |
| `enable_encryption` | `true` | Enables SSE‑S3 encryption |
| `enable_lifecycle` | `false` | Enables lifecycle rules |
| `enable_logging` | `false` | Enables access logging |
| `enable_cloudfront_cache` | `false` | Creates CloudFront distribution |
| `enable_public_access` | `false` | Allows public access (not recommended) |

### Supporting Inputs
| Variable | Description |
|----------|-------------|
| `tags` | Common resource tags |
| `lifecycle_rules` | Lifecycle rule configuration |
| `logging_bucket` | Target bucket for S3 access logs |

---

## Resources Created

Depending on feature flags, the module may create:

- S3 Bucket
- Bucket Versioning
- Server‑Side Encryption Configuration
- Public Access Block
- Access Logging Configuration
- Lifecycle Policies
- CloudFront Distribution with Origin Access Control (OAC)

---

## Outputs

| Output | Description |
|--------|-------------|
| `bucket_id` | ID of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `cloudfront_domain` | CloudFront domain (if enabled) |

---

## Example Usage

```hcl
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
```

---

## Security Considerations

### Recommended for Production
- Keep **public access disabled**
- Use **CloudFront with OAC** instead of public buckets
- Enable **access logging** to centralized log bucket
- Add **KMS encryption** (future enhancement)
- Configure **replication for disaster recovery**

---

## Future Enterprise Enhancements

Planned upgrades to align with large‑scale AWS environments:

- KMS‑based encryption with key policies
- Cross‑region replication for DR
- Bucket policy sub‑module for CloudFront‑only access
- Object ownership enforcement (ACL disabled)
- Security headers + WAF integration via CloudFront
- Terraform registry‑ready versioning & documentation

---

## When to Use This Module

Use this module when you need:
- Secure S3 bucket provisioning in Terraform
- Optional CDN caching via CloudFront
- Reusable infrastructure across environments
- Enterprise‑grade governance controls

---

## Authoring Philosophy

This module follows **real‑world enterprise DevOps standards** similar to:
- Multi‑service ECS Fargate platforms
- Centralized logging & monitoring architectures
- Cost‑optimized and secure AWS foundations

It is intentionally built to scale with **production‑grade cloud platforms**, not just simple demos.
