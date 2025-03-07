resource "aws_security_group" "image_builder" {
  name        = "${var.image_builder_ami_name_tag}-sg"
  description = "Security group for Image Builder"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}