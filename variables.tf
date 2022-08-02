variable "region" {
  type        = string
  description = "The AWS region."
}

variable "profile" {
  type        = string
  description = "The AWS CLI profile name."
}

variable "image_builder_ec2_iam_role_name" {
  type        = string
  description = "The EC2's IAM role name."
}

variable "image_builder_aws_s3_log_bucket" {
  type        = string
  description = "The S3 bucket name to send logs to."
}

variable "image_builder_aws_s3_bucket" {
  type        = string
  description = "The S3 bucket name that stores the Image Builder componeent files."
}

variable "image_builder_ebs_root_vol_size" {
  type = number
}

variable "image_builder_aws_key_pair_name" {
  type = string
}

variable "image_builder_image_receipe_version" {
  type = string
}

variable "image_builder_ami_name_tag" {
  type = string
}

variable "image_builder_linux" {
  type = bool
}

variable "image_builder_instance_types" {
  type = list(string)
}

variable "image_builder_recepie_name" {
  type = string
  default = "AWS_IMAGE_BUILDER"
}

variable "image_builder_ebs_root_vol_type" {
  type    = string
  default = "gp3"
}

variable "image_builder_infr_conf_name" {
  type = string
  default = "AWS_IMAGE_BUILDER"
}

variable "image_builder_enabled"{
  type    = bool
  default = true
}

variable "image_builder_schedule" {
  type    = string
  default = "cron(0 8 ? * tue)"
}

variable "image_builder_subnet_name" {
  type = string
}

variable "image_builder_security_group_name" {
  type = string
}