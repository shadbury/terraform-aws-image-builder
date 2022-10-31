resource "aws_sns_topic" "builder" {
  name = "image-builder-topic"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.builder.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.builder_function.arn
}

