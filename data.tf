
data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = each.value.service_account_name == "nuke" ? [
      for k, v in local.explorer_components : aws_secretsmanager_secret.this[k].arn
      ] : [
      aws_secretsmanager_secret.this[each.key].arn
    ]
  }

  for_each = local.explorer_components
}
