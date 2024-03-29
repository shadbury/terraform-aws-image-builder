data "aws_iam_policy_document" "image_builder" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "ec2:*",
      "kms:Decrypt",
      "kms:DescribeKey",
      "imagebuilder:GetComponent",

    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:List",
      "s3:GetObject"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:/aws/imagebuilder/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["*"]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "kms:EncryptionContextKeys"

      values = [
        "aws:imagebuilder:arn"
      ]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"

      values = [
        "imagebuilder.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy_attachment" "instanceProfile" {
  name       = "builder-instance-profile-policy"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_policy_attachment" "SSMManagedInstanceCore" {
  name       = "builder-SSM-policy"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}