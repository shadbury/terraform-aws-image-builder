resource "aws_iam_role" "this" {
  name = var.image_builder_ec2_iam_role_name
  path = "/"

  assume_role_policy = file("${path.module}/files/assumption-policy.json")
}

resource "aws_iam_instance_profile" "this" {
  name = var.image_builder_ec2_iam_role_name
  role = aws_iam_role.this.name
}

resource "aws_iam_policy" "this" {
  name        = var.image_builder_ec2_iam_role_name
  path        = "/"
  policy      = data.aws_iam_policy_document.image_builder.json
}

resource "aws_iam_policy_attachment" "this" {
  name       = var.image_builder_ec2_iam_role_name
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}


resource "aws_iam_role" "lambda" {
  name = "iam_for_lambda_with_sns"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "builder-policy"
  path        = "/"
  description = "builder_policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:StartInstanceRefresh",
          "autoscaling:Describe*",
          "autoscaling:UpdateAutoScalingGroup",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DescribeLaunchTemplates",
          "ec2:RunInstances",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "builder-attach" {
  name       = "builder-attachment"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSns"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.builder_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.builder.arn
}