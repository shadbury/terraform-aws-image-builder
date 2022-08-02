resource "aws_s3_bucket_object" "this" {
  for_each = fileset("${path.module}/files/", "*")

  bucket = aws_s3_bucket.s3.id
  key    = "${path.module}/files/${each.value}"
  source = "${path.module}/files/${each.value}"
  # If the md5 hash is different it will re-upload
  etag = filemd5("${path.module}/files/${each.value}")
}

resource "aws_kms_key" "image-builder" {
  description             = "KMS key for image builder"
}

# Amazon Cloudwatch agent component
resource "aws_imagebuilder_component" "cw_agent" {
  name       = "amazon-cloudwatch-agent-linux"
  platform   = "Linux"
  uri        = "s3://${aws_s3_bucket.s3.id}/files/amazon-cloudwatch-agent-linux.yml"
  version    = "1.0.1"
  kms_key_id = aws_kms_key.image-builder.arn

  depends_on = [
    aws_s3_bucket_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "image_builder" {
  name        = "image-builder"
  description = "image-builder"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "logging_bucket" {
    bucket = "${var.image_builder_aws_s3_bucket}-logging"
    acl = "private"
    
    tags = {
    Name        = var.image_builder_aws_s3_bucket
  }

  logging {
    target_bucket = "${var.image_builder_aws_s3_bucket}-logging"
    target_prefix = var.image_builder_aws_s3_bucket
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "s3" {
    bucket = var.image_builder_aws_s3_bucket
    acl = "private"
    
    tags = {
    Name        = var.image_builder_aws_s3_bucket
  }

  logging {
    target_bucket = aws_s3_bucket.logging_bucket.id
    target_prefix = var.image_builder_aws_s3_bucket
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_Access_log" {
    bucket = "${var.image_builder_aws_s3_bucket}-logging"
    
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "s3_Access" {
    bucket = var.image_builder_aws_s3_bucket
    
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.image_builder_aws_s3_bucket
  policy = jsonencode(
    {
          Id        = "BUCKET-POLICY"
          Statement = [
              {
                  Action    = "s3:*"
                  Condition = {
                      Bool = {
                          "aws:SecureTransport" = "false"
                        }
                    }
                  Effect    = "Deny"
                  Principal = "*"
                  Resource  = [
                      "arn:aws:s3:::${var.image_builder_aws_s3_bucket}/*",
                      "arn:aws:s3:::${var.image_builder_aws_s3_bucket}",
                    ]
                  Sid       = "AllowSSLRequestsOnly"
                },
            ]
          Version   = "2012-10-17"
        }
    )
}

resource "aws_s3_bucket_policy" "logging_bucket_policy" {
    bucket = "${var.image_builder_aws_s3_bucket}-logging"
    policy = jsonencode(
    {
          Id        = "BUCKET-POLICY"
          Statement = [
              {
                  Action    = "s3:*"
                  Condition = {
                      Bool = {
                          "aws:SecureTransport" = "false"
                        }
                    }
                  Effect    = "Deny"
                  Principal = "*"
                  Resource  = [
                      "arn:aws:s3:::${var.image_builder_aws_s3_bucket}-logging/*",
                      "arn:aws:s3:::${var.image_builder_aws_s3_bucket}-logging",
                    ]
                  Sid       = "AllowSSLRequestsOnly"
                },
            ]
          Version   = "2012-10-17"
        }
    )
}
