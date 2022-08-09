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