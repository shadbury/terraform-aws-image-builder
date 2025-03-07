resource "aws_imagebuilder_distribution_configuration" "this" {
  name = "${var.image_builder_ami_name_tag}-distribution"

  distribution {
    region = var.region
    ami_distribution_configuration {
      name = "${var.image_builder_ami_name_tag}-{{ imagebuilder:buildDate }}"
      ami_tags = {
        Name        = var.image_builder_ami_name_tag
        CreatedBy   = "AWS Image Builder"
        BuildDate   = "{{ imagebuilder:buildDate }}"
      }
    }
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = "${var.image_builder_ami_name_tag}-infra"
  instance_profile_name         = aws_iam_instance_profile.image_builder.name
  instance_types                = var.image_builder_instance_types
  security_group_ids            = [aws_security_group.image_builder.id]
  subnet_id                     = var.subnet_id
  terminate_instance_on_failure = true
}

resource "aws_imagebuilder_image" "custom" {
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.custom.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn

  # Ensure the image build completes before proceeding
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_imagebuilder_image_recipe" "custom" {
  name         = var.image_builder_ami_name_tag
  version      = var.image_builder_image_recipe_version
  parent_image = var.custom_ami_id != null ? var.custom_ami_id : data.aws_ami.base_image[0].id

  block_device_mapping {
    device_name = var.image_type == "windows" ? "/dev/sda1" : "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = var.image_builder_ebs_root_vol_size
      volume_type           = "gp3"
      encrypted             = true
    }
  }

  dynamic "component" {
    for_each = aws_imagebuilder_component.custom[*].arn
    content {
      component_arn = component.value
    }
  }

  depends_on = [aws_imagebuilder_component.custom]
}