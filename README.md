# AWS Image Builder Terraform Module
[![Terraform](https://img.shields.io/badge/Terraform-0.12%2B-blue.svg)](https://www.terraform.io)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/badge/GitHub-Repo-blue.svg)](

## Overview
This Terraform module creates an AWS Image Builder pipeline to build custom AMIs based on either Windows Server 2022, Amazon Linux 2, or a user-specified custom AMI. It supports dynamic configuration for the parent image, custom components, and EC2 instance deployment within the same stack.

## Features

- **Dynamic Image Type**: Choose between Windows (windows) or Linux (linux) base images, or provide a custom AMI ID.
- **Custom Components**: Apply custom Image Builder components (e.g., PowerShell scripts for Windows, Bash scripts for Linux).
- **EC2 Integration**: Outputs the generated AMI ID and optionally deploys an EC2 instance using it.
- **Flexible Configuration**: Adjustable EBS volume size, instance types, and VPC/subnet settings.


## Configuration

This module is designed to be imported into a parent Terraform configuration. To use it:

### Import the Module

Include this module in your Terraform configuration.

### Provide Component Data

Pass custom component definitions via the `custom_components` variable (see Variables section). Components should be provided as a list of objects with YAML content, names, and platforms.

### Set Variables

Configure required variables through the parent configuration (e.g., via `terraform.tfvars` or module inputs).

### Apply the Configuration

Run `terraform init` and `terraform apply` from the parent directory.


## Variables

| Variable                             | Type          | Description                                           | Default       |
|--------------------------------------|---------------|-------------------------------------------------------|---------------|
| `region`                             | `string`      | AWS region for deployment                             | -             |
| `image_type`                         | `string`      | Image type (`windows` or `linux`)                     | `"windows"`   |
| `custom_ami_id`                      | `string`      | Custom AMI ID (overrides `image_type` if set)         | `null`        |
| `image_builder_ami_name_tag`         | `string`      | Name tag for the AMI and resources                    | -             |
| `image_builder_ebs_root_vol_size`    | `number`      | Root volume size in GB                                | `20`          |
| `image_builder_image_recipe_version` | `string`      | Version of the image recipe                           | `"1.0.0"`     |
| `image_builder_instance_types`       | `list(string)`| Instance types for building the image                 | `["t3.medium"]`|
| `subnet_id`                          | `string`      | Subnet ID for Image Builder instance                  | -             |
| `vpc_id`                             | `string`      | VPC ID for Image Builder resources                    | -             |
| `image_builder_ec2_iam_role_name`    | `string`      | IAM role name for Image Builder                       | -             |
| `custom_components`                  | `list(object)`| List of custom components with `file_path` (content), `name`, `description`, `platform` | `[]`          |


## Notes

### Component Input
The `custom_components` variable expects a list of objects containing the component YAML content (`file_path`), name, description, and platform (e.g., "Windows" or "Linux"). The parent configuration must provide this data.

### Custom AMI
If using `custom_ami_id`, ensure it exists in the target region and is accessible.

### Build Time
Image creation may take 15-30 minutes, depending on components and AWS processing.

## Troubleshooting

### Invalid AMI Error
Verify the `custom_ami_id` or ensure default AMIs (Windows Server 2022, Amazon Linux 2) are available in the target region.

### Component Errors
Validate that `custom_components` contains valid YAML content compatible with the target OS.

### Permissions
Confirm the IAM role specified in `image_builder_ec2_iam_role_name` has sufficient permissions (see `iam.tf`).

