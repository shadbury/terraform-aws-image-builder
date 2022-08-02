data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_subnet" "this" {
  filter {
    name   = "tag:Name"
    values = [var.image_builder_subnet_name]
  }
}

data "aws_security_group" "this" {
  filter {
    name   = "tag:Name"
    values = [var.image_builder_security_group_name]
  }
}