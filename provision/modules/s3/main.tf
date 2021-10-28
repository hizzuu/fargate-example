resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-sample"
  versioning {
    enabled = true
  }
  tags = {
    Service     = var.service
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "fargate-sample-alb"
  versioning {
    enabled    = false
    mfa_delete = false
  }
  force_destroy = true
  tags = {
    Service     = var.service
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::582318560864:root"
          }
          Action   = "s3:PutObject"
          Resource = "${aws_s3_bucket.log_bucket.arn}/*"
        },
        {
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action   = "s3:PutObject"
          Resource = "${aws_s3_bucket.log_bucket.arn}/*"
          Condition = {
            StringEquals = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
            }
          }
        },
        {
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action   = "s3:GetBucketAcl",
          Resource = "${aws_s3_bucket.log_bucket.arn}"
        }
      ]
    }
  )
}
