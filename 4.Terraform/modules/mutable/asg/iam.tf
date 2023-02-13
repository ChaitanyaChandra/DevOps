resource "aws_iam_policy" "policy" {
  name        = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-secrets-readonly-policy"
  path        = "/"
  description = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-secrets-readonly-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter",
          "secretsmanager:ListSecrets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "role" {
  name = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-secrets-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-secrets-readonly-role"
  }
}

resource "aws_iam_role_policy_attachment" "policy-to-role-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${local.tags.Service}-${local.Environment}-${local.env_tag.appenv}-secrets-readonly-role"
  role = aws_iam_role.role.name
}
