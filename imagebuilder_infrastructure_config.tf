resource "aws_imagebuilder_infrastructure_configuration" "this" {
  instance_profile_name         = aws_iam_instance_profile.this.name
  instance_types                = var.image_builder_instance_types
  key_pair                      = var.image_builder_aws_key_pair_name != null ? aws_key_pair.keypair_public[0].id : var.image_builder_aws_key_pair_name
  name                          = var.image_builder_infr_conf_name
  security_group_ids            = [aws_security_group.image_builder.id]
  subnet_id                     = data.aws_subnet.this.id
  terminate_instance_on_failure = var.terminate_instance_on_failure
  sns_topic_arn                 = aws_sns_topic.builder.arn
}