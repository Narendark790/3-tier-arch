# IAM Users

# Create IAM users
resource "aws_iam_user" "usr" {
  for_each = toset(local.users)
  name     = each.value
}

locals {
  users = ["gout-1", "gout-2", "gout-3"]
}

# S3 Read Only Access
resource "aws_iam_user_policy_attachment" "s3-read" {
  for_each   = toset(local.users)
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  user       = aws_iam_user.usr[each.value].name
}

# EC2 Read Only Access
resource "aws_iam_user_policy_attachment" "ec2-read" {
  for_each   = toset(local.users)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  user       = aws_iam_user.usr[each.value].name
}
