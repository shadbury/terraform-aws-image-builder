data "aws_iam_policy_document" "image_builder" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:*",
      "ec2:*",
      "imagebuilder:*",
      "s3:GetObject",
      "s3:ListBucket",
      "kms:Decrypt",
      "kms:DescribeKey",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "image_builder" {
  name = var.image_builder_ec2_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "image_builder" {
  name = var.image_builder_ec2_iam_role_name
  role = aws_iam_role.image_builder.name
}

resource "aws_iam_role_policy" "image_builder_policy" {
  name   = "${var.image_builder_ec2_iam_role_name}-policy"
  role   = aws_iam_role.image_builder.id
  policy = data.aws_iam_policy_document.image_builder.json
}