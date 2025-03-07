resource "aws_imagebuilder_image_pipeline" "custom" {
  name                             = var.image_builder_ami_name_tag
  status                           = "ENABLED"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.custom.arn
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
    aws_imagebuilder_image_recipe.custom,
    aws_imagebuilder_infrastructure_configuration.this
  ]
}