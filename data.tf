
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = concat(
      [
        aws_secretsmanager_secret.this[each.key].arn
      ],
      try(each.value.secret_manager_arns, [])
    )
  }

  for_each = local.explorer_components
}
