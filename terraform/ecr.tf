# ECRリポジトリ
resource "aws_ecr_repository" "aws_ecr_repository_module" {
  name                 = var.aws_ecr_repository_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_iam_role_policy_attachment" "aws_iam_ecr_role_ecr_policy_attachment_module" {
  role       = aws_iam_role.aws_iam_ecr_role_module.name
  policy_arn = aws_iam_policy.aws_iam_ecr_policy_module.arn
}