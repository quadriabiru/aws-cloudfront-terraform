resource "aws_cloudfront_origin_access_control" "example" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_s3_bucket" "example" {
    bucket = "<BUCKET NAME>"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = data.aws_s3_bucket.example.bucket_domain_name # S3 bucket regional domain name
        origin_access_control_id = aws_cloudfront_origin_access_control.example.id # Need to create OAC
        origin_id = "S3 static website" # S3 Origin ID
    }

    # By default, show index.html file
    default_root_object = "index.html"
    enabled = true
    is_ipv6_enabled = true

    aliases = ["*.example.com"] # CNAMES

    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "S3 static website" # S3 Origin ID
 
        # Forward all query strings, cookies and headers
        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }

        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
        compress = true
    }

    # Distributes content to US and Europe
    price_class = "PriceClass_200"

    # Restricts who is able to access this content
    restrictions {
        geo_restriction {
            # type of restriction, blacklist, whitelist or none
            restriction_type = "none"
        }
    }

    # SSL certificate for the service.
    viewer_certificate {
        acm_certificate_arn = "<CERTIFICATE ARN>"
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1" 
    }
}

# Afterwards create Rout 53 entry to cloudfront distribution with CDN