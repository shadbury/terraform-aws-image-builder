resource "aws_s3_bucket_object" "this" {
  for_each = fileset("${path.module}/files/", "*")

  bucket = module.image-builder.module.s3.aws_s3_bucket.s3_log[0].id
  key    = "${path.module}/files/${each.value}"
  source = "${path.module}/files/${each.value}"
  # If the md5 hash is different it will re-upload
  etag = filemd5("${path.module}/files/${each.value}")
}

module "s3" {
  source                = "shadbury/s3/aws"
  version               = "1.0.3"
  bucket_key            = var.image_builder_aws_s3_bucket
  create_logging_bucket = true
  logging_bucket        = "${var.image_builder_aws_s3_bucket}-logging"
  public_access         = false
}

resource "aws_kms_key" "image-builder" {
  description             = "KMS key for image builder"
}

# Amazon Cloudwatch agent component
resource "aws_imagebuilder_component" "cw_agent" {
  name       = "amazon-cloudwatch-agent-linux"
  platform   = "Linux"
  uri        = "s3://${var.image_builder_aws_s3_bucket}/files/amazon-cloudwatch-agent-linux.yml"
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