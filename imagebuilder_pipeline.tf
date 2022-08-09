resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = var.image_builder_ami_name_tag
  status                           = var.image_builder_enabled ? "ENABLED" : "DISABLED"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this[count.index].arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.this.arn

  schedule {
    schedule_expression = var.image_builder_schedule
    pipeline_execution_start_condition = "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE"
  }

  image_tests_configuration {
    image_tests_enabled = true
    timeout_minutes     = 60
  }

  tags = {
    "Name" = "${var.image_builder_ami_name_tag}-pipeline"
  }

  depends_on = [
    aws_imagebuilder_image_recipe.this[count.index],
    aws_imagebuilder_infrastructure_configuration.this
  ]
}