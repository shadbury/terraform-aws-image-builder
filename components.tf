resource "aws_imagebuilder_component" "custom" {
  count = length(var.custom_components) != null ? length(var.custom_components) : 0
  
  data     = local_file.custom_components[count.index].content
  name     = var.custom_components[count.index].name
  platform = var.custom_components[count.index].platform
  version  = "1.0.0"
}

data "aws_imagebuilder_components" "linux" {
  owner = "Amazon"

  filter {
    name   = "name"
    values = var.component_names
  }
}