module "monitoring" {
  source = "git@github.com:Aventus-Network-Services/terraform-aws-rds-monitoring?ref=v0.1.0"

  sns_topic         = var.monitoring_sns_topic
  alarm_name_prefix = "${title(var.environment)}-${each.value.id}"
  db_instance_id    = each.value.id
  tags              = var.tags

  for_each = module.db.cluster_instances
}

resource "aws_secretsmanager_secret" "rds" {
  name = "${var.secret_manager_settings.prefix}/rds_db_config"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode(
    {
      username = module.db.cluster_master_username
      password = module.db.cluster_master_password
      engine   = "postgres"
      host     = module.db.cluster_endpoint
    }
  )
}

#
# Setup AWS EKS IAM Role for reading secrets stored in AWS Secret Manager
#
module "eks_iam_role" {
  source  = "cloudposse/eks-iam-role/aws"
  version = "v2.1.1"

  environment                 = var.environment
  name                        = "${var.eks_iam_role_settings.prefix}-${each.value.service_account_name}-sa"
  aws_account_number          = data.aws_caller_identity.this.account_id
  eks_cluster_oidc_issuer_url = var.eks_iam_role_settings.eks_cluster_oidc_issuer_url
  service_account_name        = each.value.service_account_name
  service_account_namespace   = var.eks_iam_role_settings.service_account_namespace
  aws_iam_policy_document = [
    data.aws_iam_policy_document.eks_iam_policy[each.key].json
  ]
  tags = var.tags

  for_each = {
    for k, v in local.explorer_components : k => v
    if v.enabled
  }
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.secret_manager_settings.prefix}/${each.key}"
  recovery_window_in_days = var.secret_manager_settings.recovery_window_in_days
  kms_key_id              = var.secret_manager_settings.kms_key_id
  tags                    = var.tags

  for_each = {
    for k, v in local.explorer_components : k => v
    if v.enabled
  }
}


module "opensearch" {
  source = "git@github.com:Aventus-Network-Services/terraform-aws-module-opensearch.git?ref=v1.0.0"

  name                            = var.opensearch_settings.name
  enviroment                      = var.environment
  vpc_id                          = var.vpc_settings.vpc_id
  subnet_ids                      = var.opensearch_settings.subnet_ids
  zone_awareness_enabled          = var.opensearch_settings.zone_awareness_enabled
  availability_zone_count         = var.opensearch_settings.availability_zone_count
  engine_version                  = var.opensearch_settings.engine_version
  instance_type                   = var.opensearch_settings.instance_type
  instance_count                  = var.opensearch_settings.instance_count
  ebs_volume_size                 = var.opensearch_settings.ebs_volume_size
  ebs_iops                        = var.opensearch_settings.ebs_iops
  ebs_volume_type                 = var.opensearch_settings.ebs_volume_type
  encrypt_at_rest_enabled         = var.opensearch_settings.encrypt_at_rest_enabled
  encrypt_at_rest_kms_key_id      = var.opensearch_settings.encrypt_at_rest_kms_key_id
  node_to_node_encryption_enabled = var.opensearch_settings.node_to_node_encryption_enabled
  security_groups                 = var.opensearch_settings.allowed_security_groups
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = var.tags
}

resource "aws_opensearch_domain_policy" "this" {
  domain_name     = module.opensearch.domain_name
  access_policies = data.aws_iam_policy_document.os_explorer_policy.json
}

module "os_monitoring" {
  source = "git@github.com:Aventus-Network-Services/terraform-aws-module-elasticsearch-cloudwatch-alerts?ref=v1.1.0"

  sns_topic                                = var.monitoring_sns_topic
  alarm_name_prefix                        = "${title(var.environment)}-${var.opensearch_settings.name}-"
  domain_name                              = module.opensearch.domain_name
  monitor_cluster_status_is_yellow         = false
  monitor_free_storage_space_total_too_low = true
  tags                                     = var.tags
}
