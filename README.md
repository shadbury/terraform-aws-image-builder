# Notes

THIS IS A TERRAFORM MODULE AND NEEDS TO BE REFERENECED FROM A MODULE BLOCK IN A TF FILE. 

This module is designed to update an already existing launch configuration.

The module will create: 

``ec2 imagebuilder pipeline``
``ec2 imagebuilder recipe``
``ec2 imagebuilder distribution config``
``ec2 imagebuilder image``
``ec2 imagebuilder infrasutucture config``


# Architecture
![Architecture](/media/architecture-diagram.png)

This solution uses `ec2 image builder`, `ec2 image builder pipeline`, `Lambda` and `sns`

The image builder has a pipeline that will trigger the image build.
The image builder will update the current AMI in the given launch template.
When the build is complete, the pipeline will trigger a notification to be sent to the SNS queue.
The SNS queue will trigger a lambda function to start an instance refresh for the given ASG.
# EC2 Imagebuilder Pipeline

The image builder pipeline will use the ec2 image builder image, ec2 image builder recipe, ec2 image builder distribution config and the ec2 imagebuilder infrustructure config.

The pipeline requires an already existing launch template id. This will be used to update the launch template with a new version containing the new AMI after the build is completed and tested.

## EC2 Imagebuilder Recipe

The Imagebuilder Recipe contains a list of values used by the ec2 imagebuilder image. 

The Recipe requires Components to be listed, this is installed and used to test the image before completing the creation of the AMI


## example main.tf
```
module "image-builder" {
  source  = "shadbury/image-builder/aws"
  version = "1.0.0"

  profile                             = local.workspace["aws_profile"]
  region                              = local.workspace["region"]
  image_builder_ami_name_tag          = local.workspace["image_builder_ami_name_tag"]
  image_builder_aws_key_pair_name     = local.workspace["image_builder_aws_key_pair_name"]
  image_builder_ebs_root_vol_size     = local.workspace["image_builder_ebs_root_vol_size"]
  image_builder_ec2_iam_role_name     = local.workspace["image_builder_ec2_iam_role_name"]
  image_builder_image_recipe_version  = local.workspace["image_builder_image_recipe_version"]
  image_builder_instance_types        = local.workspace["image_builder_instance_types"]
  image_builder_subnet_name           = local.workspace["image_builder_subnet_name"]
  vpc_id                              = local.workspace["vpc_id"]
  component_names                     = local.workspace["component_names"]
  launch_template_id                  = local.workspace["launch_template_id"]
  userdata                            = base64encode(file("./files/userdata.template"))
}
```

## example locals.tf
```
locals {

  client = "test-client"
env = {

  shadbolt = {
        aws_profile                        = "shadbolts-admin"
        region                             = "ap-southeast-2"
        image_builder_ami_name_tag         = "shadbury"
        image_builder_aws_key_pair_name    = "openvpn"
        image_builder_ebs_root_vol_size    = 30
        image_builder_ec2_iam_role_name    = "image_builder_role"
        image_builder_image_recipe_version = "1.0.0"
        image_builder_instance_types       = ["t2.small"]
        image_builder_subnet_name          = "test"
        vpc_id                             = "vpc-7d5b421a"
        component_names                    = ["amazon-cloudwatch-agent-linux"]
        launch_template_id                 = "lt-0e7cac7a1cb2706e1"
      
    }
}
  workspace = local.env[terraform.workspace]
}
```
