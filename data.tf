
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = each.value.service_account_name == "nuke" ? [
      for k, v in local.explorer_components : aws_secretsmanager_secret.this[k].arn
      if v.enabled
      ] : [
      aws_secretsmanager_secret.this[each.key].arn
    ]
  }

  for_each = {
    for k, v in local.explorer_components : k => v
    if v.enabled
  }
}

data "aws_iam_policy_document" "os_explorer_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    resources = [
      "arn:aws:es:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:domain/${module.opensearch.domain_name}/*"
    ]
    actions = [
      "es:*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
