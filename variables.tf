variable "region" {
  type        = string
  description = "AWS region for deployment"
}

variable "image_builder_ami_name_tag" {
  type        = string
  description = "Name tag for the AMI and related resources"
}

variable "image_builder_ebs_root_vol_size" {
  type        = number
  description = "Size of the root volume in GB"
  default     = 20
}

variable "image_builder_ec2_iam_role_name" {
  type        = string
  description = "Name of the IAM role for EC2 Image Builder"
}

variable "image_builder_image_recipe_version" {
  type        = string
  description = "Version of the image recipe (e.g., 1.0.0)"
  default     = "1.0.0"
}

variable "image_builder_instance_types" {
  type        = list(string)
  description = "List of instance types for building the image"
  default     = ["t3.medium"]
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Image Builder instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for Image Builder resources"
}

variable "custom_components" {
  type = list(object({
    file_path   = string
    name        = string
    description = string
    platform    = string
  }))
  default = []
}

variable "image_builder_schedule" {
  type        = string
  description = "Schedule expression for the image build"
}

variable "image_type" {
  type        = string
  description = "Type of image to build (e.g., windows, linux)"
}

variable "custom_ami_id" {
  type        = string
  description = "Custom AMI ID to use as the base image"
  default     = null
}