resource "aws_lambda_function" "ssm_alerts_function" {
  function_name = "image-builder-trigger-refresh"
  role          = aws_iam_role.lambda.arn
  handler       = "instance_refresh.lambda_handler"
  runtime       = "python3.9"
  filename      = "instance_refresh.zip"
  source_code_hash = "${data.archive_file.zipit.output_base64sha256}"

  environment {
    variables = {
      AutoScalingGroupName = var.asg_name
      LaunchTemplateId = var.launch_template_id
    }
  }
}