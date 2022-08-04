resource "aws_kms_key" "image-builder" {
  description             = "KMS key for image builder"
}

resource "local_file" "userdata" {
  content = var.userdata
  filename = "userdata.template"
}

data "aws_imagebuilder_components" "linux" {
  owner = "Amazon"

  filter {
    name   = "name"
    values = var.component_names
  }
}

resource "aws_security_group" "image_builder" {
  name        = "image-builder"
  description = "image-builder"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "sg_ingress_rules" {
  count = length(var.sg_ingress_rules)

  type              = "ingress"
  from_port         = var.sg_ingress_rules[count.index].from_port
  to_port           = var.sg_ingress_rules[count.index].to_port
  protocol          = var.sg_ingress_rules[count.index].protocol
  cidr_blocks       = var.sg_ingress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.image_builder.id
}


resource "aws_security_group_rule" "sg_egress_rules" {
  count = length(var.sg_egress_rules)

  type              = "egress"
  from_port         = var.sg_egress_rules[count.index].from_port
  to_port           = var.sg_egress_rules[count.index].to_port
  protocol          = var.sg_egress_rules[count.index].protocol
  cidr_blocks       = var.sg_egress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.image_builder.id
}


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