resource "aws_imagebuilder_component" "custom" {
  count    = length(var.custom_components)
  data     = var.custom_components[count.index].file_path 
  name     = var.custom_components[count.index].name
  platform = var.custom_components[count.index].platform
  version  = "1.0.0"
}