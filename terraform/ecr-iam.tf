# ECRロール
resource "aws_iam_role" "aws_iam_ecr_role_module" {
  name               = "ecr-role"
  assume_role_policy = jsonencode(
    {
      "Version"   = "2012-10-17"
      "Statement" = [
        {
          "Action" = [
            "sts:AssumeRole",
            "sts:AssumeRoleWithWebIdentity"
          ]
          "Principal" = {
            "Service"   = "ec2.amazonaws.com"
            "Federated" = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
          "Condition" = {
            "StringEquals" = {
              "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            }
            "StringLike" = {
              "token.actions.githubusercontent.com:sub" = "repo:${var.github_id}/${var.github_repository_name}:*"
            }
          }
          "Effect" = "Allow"
          "Sid"    = ""
        }
      ]
    }
  )
}

# ECRポリシー
resource "aws_iam_policy" "aws_iam_ecr_policy_module" {
  name        = "ecr-policy"
  description = "Policy to allow pushing to ECR"
  policy      = jsonencode(
    {
      "Version"   = "2012-10-17"
      "Statement" = [
        {
          "Sid"    = "AuthOnly"
          "Effect" = "Allow"
          "Action" = [
            "ecr:GetAuthorizationToken"
          ]
          "Resource" = "*"
        },
        {
          "Effect"   = "Allow"
          "Action"   = "lambda:InvokeFunction"
          "Resource" = "*"
        },
        {
          "Effect"   = "Allow"
          "Action"   = "ecs:UpdateService"
          "Resource" = "*"
        },
        {
          "Effect" = "Allow"
          "Action" = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchDeleteImage",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecr:DescribeImages"
          ]
          "Resource" = "arn:aws:ecr:ap-northeast-1:${var.aws_account_id}:repository/${var.aws_ecr_repository_name}"
        }
      ]
    }
  )
}