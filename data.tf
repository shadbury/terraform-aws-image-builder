data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_imagebuilder_image" "latest" {
  arn = aws_imagebuilder_image_recipe.custom.arn
}

data "aws_ami" "base_image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [lower(var.image_type) == "windows" ? "Windows_Server-2022-English-Full-Base-*" : "amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}