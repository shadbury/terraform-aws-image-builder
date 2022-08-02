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
  description = "IAM ec2 instance profile for the Image Builder instances."
  policy      = data.aws_iam_policy_document.image_builder.json
}

resource "aws_iam_policy_attachment" "this" {
  name       = var.image_builder_ec2_iam_role_name
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}