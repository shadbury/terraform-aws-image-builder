resource "aws_s3_bucket_object" "this" {
  for_each = fileset("/files/", "*")

  bucket = var.image_builder_aws_s3_bucket
  key    = "${path.module}/files/${each.value}"
  source = "${path.module}/files/${each.value}"
  # If the md5 hash is different it will re-upload
  etag = filemd5("/files/${each.value}")
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
  kms_key_id = aws_kms_key.image-builder

  depends_on = [
    aws_s3_bucket_object.this
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "image-builder" {
  name        = "image-builder"
  description = "image-builder"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}