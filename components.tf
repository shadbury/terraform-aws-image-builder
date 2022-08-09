resource "aws_imagebuilder_component" "custom" {
  count = length(var.custom_components) != null ? length(var.custom_components) : 0
  
  data     = local_file.custom_components[count.index].content
  #uri      = "s3://${aws_s3_bucket.s3.id}/${path.module}/files/${local_file.custom_components[count.index].filename}"
  name     = var.custom_components[count.index].name
  platform = var.custom_components[count.index].platform
  version  = "1.0.0"
  depends_on = [
    aws_s3_bucket_object.this
  ]
}

data "aws_imagebuilder_components" "linux" {
  owner = "Amazon"

  filter {
    name   = "name"
    values = var.component_names
  }
}