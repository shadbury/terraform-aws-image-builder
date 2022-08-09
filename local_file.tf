resource "local_file" "userdata" {
  content = var.userdata
  filename = "${path.module}/userdata.template"
}

resource "local_file" "custom_components" {
  count = length(var.custom_components) != 0 ? length(var.custom_components) : 0
  content = var.custom_components[count.index].file_path
  filename = "${path.module}/${var.custom_components[count.index].name}.yml"
}
