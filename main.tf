data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_subnet" "this" {
  filter {
    name   = "tag:Name"
    values = [var.image_builder_subnet_name]
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}