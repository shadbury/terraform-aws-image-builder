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

variable "image_builder_ebs_root_vol_size" {
  type = number
  description = "size of image_builder root volume"
}

variable "image_builder_aws_key_pair_name" {
  type        = string
  description = "Key Pair to use with image_builder"
  default     = null
}

variable "image_builder_image_recipe_version" {
  type = string
  default = "1.0.0"
  description = "Recipe version for Image builder - Must match syntax ^[0-9]+\\.[0-9]+\\.[0-9]+$"
}

variable "image_builder_ami_name_tag" {
  type = string
  description = "Name tag for AMI"
}

variable "image_builder_ami" {
  type = string
  default = null
  description = "Provide a custom AMI if required, default will use the latest Amazon Linux 2 AMI"
}

variable "image_builder_instance_types" {
  type = list(string)
  description = "Instance types to be used during the build process"
}

variable "image_builder_recipe_name" {
  type = string
  default = "AWS_IMAGE_BUILDER"
  description = "Name for image_builder_recipe"
}

variable "image_builder_ebs_root_vol_type" {
  type    = string
  default = "gp3"
  description = "type of volume to be used by the image builder"
}

variable "image_builder_infr_conf_name" {
  type = string
  default = "AWS_IMAGE_BUILDER"
  description = "Infrastructure configuration name"
}

variable "image_builder_enabled"{
  type    = bool
  default = true
  description = "set pipeline to enabled"
}

variable "image_builder_schedule" {
  type    = string
  default = "cron(0 8 ? * tue)"
  description = "Cron value for pipeline trigger"
}

variable "image_builder_subnet_name" {
  type = string
  description = "enter the subnet name for the image builder"
}

variable "vpc_id" {
  type = string
  description = "VPC id to be used by the image builder"
}

variable "userdata"{
  description = "File path for userdata to be triggered by the image builder"
}

variable "component_names" {
  type = list(string)
  description = "AMAZON managed applications to install https://ap-southeast-2.console.aws.amazon.com/imagebuilder/home?region=ap-southeast-2#/components"
  default = ["amazon-cloudwatch-agent-linux"]
}

variable "launch_template_id" {
  type = string
  description = "The Id of the launch Template that will receive the latest AMI after creation"
}

variable "terminate_instance_on_failure" {
  type = bool
  default = true
  description = "Terminate instance if build fails"
}

variable "sg_ingress_rules" {
  description = "inbound rules for sg"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default =[ 
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ]
}

variable "sg_egress_rules" {
  description = "egress rules for sg"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default =[ 
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ]
}

variable "custom_components" {
  type = list(object({
    file_path    = string
    name         = string
    description  = string
    platform     = string
  }))
  default = null
}