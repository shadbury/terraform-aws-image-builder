resource "aws_imagebuilder_image" "this" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn

  depends_on = [
    data.aws_iam_policy_document.image_builder,
    aws_imagebuilder_image_recipe.this,
    aws_imagebuilder_distribution_configuration.this,
    aws_imagebuilder_infrastructure_configuration.this
  ]
}

resource "aws_imagebuilder_image_recipe" "this" {
    count = length(var.custom_components) <= 1 ? 0 : length(var.custom_components)
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = var.image_builder_ebs_root_vol_size
      volume_type           = var.image_builder_ebs_root_vol_type
      encrypted             = true
    }
  }

  dynamic component {
    for_each = data.aws_imagebuilder_components.linux.arns
    content{
    component_arn = component.value
    }
  }

  name         = var.image_builder_recipe_name
  parent_image = var.image_builder_ami != null ? var.image_builder_ami : "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x" 
  version      = var.image_builder_image_recipe_version
  user_data_base64 = local_file.userdata.content

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_image" "this" {
  count = length(var.custom_components.file_path) <= 1 ? 0 : length(var.custom_components.file_path)
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn

  depends_on = [
    data.aws_iam_policy_document.image_builder,
    aws_imagebuilder_image_recipe.this,
    aws_imagebuilder_distribution_configuration.this,
    aws_imagebuilder_infrastructure_configuration.this
  ]
}

resource "aws_imagebuilder_image_recipe" "this" {
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = var.image_builder_ebs_root_vol_size
      volume_type           = var.image_builder_ebs_root_vol_type
      encrypted             = true
    }
  }

  dynamic component {
    for_each = aws_imagebuilder_component.custom[count.index].arns
    content{
    component_arn = component.value
    }
  }

  name         = var.image_builder_recipe_name
  parent_image = var.image_builder_ami != null ? var.image_builder_ami : "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x" 
  version      = var.image_builder_image_recipe_version
  user_data_base64 = local_file.userdata.content

  lifecycle {
    create_before_destroy = true
  }
}