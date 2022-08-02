resource "aws_imagebuilder_infrastructure_configuration" "this" {
  description                   = "Simple infrastructure configuration"
  instance_profile_name         = var.image_builder_ec2_iam_role_name
  instance_types                = var.image_builder_instance_types
  key_pair                      = var.image_builder_aws_key_pair_name
  name                          = var.image_builder_infr_conf_name
  security_group_ids            = [aws_security_group.image_builder.id]
  subnet_id                     = data.aws_subnet.this.id
  terminate_instance_on_failure = true

  logging {
    s3_logs {
      s3_bucket_name = "${aws_s3_bucket.logging_bucket.id}-logging"
      s3_key_prefix  = "image-builder"
    }
  }
}