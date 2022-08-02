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
  block_device_mapping {
    device_name = "/dev/xvdb"

    ebs {
      delete_on_termination = true
      volume_size           = var.image_builder_ebs_root_vol_size
      volume_type           = var.image_builder_ebs_root_vol_type
      encrypted             = true
    }
  }

  component {
    component_arn = aws_imagebuilder_component.cw_agent.arn
  }

  name         = var.image_builder_recepie_name
  parent_image = var.image_builder_linux ? "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2-x86/x.x.x" : "arn:${data.aws_partition.current.partition}:imagebuilder:${data.aws_region.current.name}:aws:image/windows-server-2022-english-core-base-x86/x.x.x"
  version      = var.image_builder_image_receipe_version

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_imagebuilder_component.cw_agent
  ]
}