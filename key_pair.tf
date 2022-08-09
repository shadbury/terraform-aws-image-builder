resource "tls_private_key" "main" {
  count = var.image_builder_aws_key_pair_name != null ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "keypair_private" {
  count = var.image_builder_aws_key_pair_name != null ? 1 : 0

  name  = "/ec2-keypairs/${var.image_builder_ami_name_tag}"
  type  = "SecureString"
  value = tls_private_key.main[0].private_key_pem
}

resource "aws_key_pair" "keypair_public" {
  count = var.image_builder_aws_key_pair_name != null ? 1 : 0

  key_name   = var.image_builder_ami_name_tag
  public_key = tls_private_key.main[0].public_key_openssh
}