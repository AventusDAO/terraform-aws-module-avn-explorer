
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "sm" {
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

data "aws_iam_policy_document" "kms" {
  count = var.secret_manager_settings.kms_key_id != null ? 1 : 0

  statement {
    actions = [
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [
      var.secret_manager_settings.kms_key_id,
    ]
  }
}

data "aws_iam_policy_document" "eks_iam_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.sm[each.key].json,
    var.secret_manager_settings.kms_key_id != null ? data.aws_iam_policy_document.kms[0].json : jsonencode({})
  ]

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
