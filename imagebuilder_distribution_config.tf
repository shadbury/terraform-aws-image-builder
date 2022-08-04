resource "aws_imagebuilder_distribution_configuration" "this" {
  name = "local-distribution"

  distribution {
    ami_distribution_configuration {
      name = "${var.profile}-{{ imagebuilder:buildDate }}"
    }
    region = var.region

    launch_template_configuration {
      account_id = data.aws_caller_identity.current.id
      launch_template_id = var.launch_template_id
    }
  }

}