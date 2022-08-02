resource "aws_imagebuilder_distribution_configuration" "this" {
  name = "local-distribution"

  distribution {
    ami_distribution_configuration {


      name = "${var.profile}-{{ imagebuilder:buildDate }}"

      launch_permission {
        # user_ids = ["123456789012"]
      }
    }
    region = var.region
  }
}