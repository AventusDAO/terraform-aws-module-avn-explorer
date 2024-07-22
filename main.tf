module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.2"

  name               = var.db_settings.name
  create_cluster     = var.db_settings.create_cluster
  engine             = var.db_settings.engine
  engine_version     = var.db_settings.engine_version
  ca_cert_identifier = var.db_settings.ca_cert_identifier
  instances          = var.db_settings.instances

  vpc_id                  = var.vpc_settings.vpc_id
  db_subnet_group_name    = var.db_settings.db_subnet_group_name
  create_db_subnet_group  = true
  allowed_security_groups = var.db_settings.allowed_security_groups
  allowed_cidr_blocks     = var.db_settings.allowed_cidr_blocks

  iam_database_authentication_enabled = var.db_settings.iam_database_authentication_enabled
  create_random_password              = var.db_settings.create_random_password

  apply_immediately   = var.db_settings.apply_immediately
  skip_final_snapshot = var.db_settings.skip_final_snapshot

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = var.db_settings.name
  db_cluster_parameter_group_family      = var.db_settings.family
  db_cluster_parameter_group_description = "${var.db_settings.name} cluster parameter group"
  db_cluster_parameter_group_parameters  = var.db_settings.db_cluster_parameter_group_parameters

  create_db_parameter_group      = true
  db_parameter_group_name        = var.db_settings.name
  db_parameter_group_family      = var.db_settings.family
  db_parameter_group_description = "${var.db_settings.name} DB parameter group"
  db_parameter_group_parameters  = var.db_settings.db_parameter_group_parameters

  enabled_cloudwatch_logs_exports       = ["postgresql"]
  performance_insights_enabled          = var.db_settings.performance_insights_enabled
  performance_insights_retention_period = var.db_settings.performance_insights_retention_period
  create_monitoring_role                = var.db_settings.create_monitoring_role
  monitoring_interval                   = var.db_settings.monitoring_interval

  tags = var.tags
}

module "monitoring" {
  source = "git@github.com:Aventus-Network-Services/terraform-aws-rds-monitoring?ref=v0.1.0"

  sns_topic         = var.monitoring_sns_topic
  alarm_name_prefix = "${title(var.environment)}-${each.key}"
  db_instance_id    = each.key
  tags              = var.tags

  for_each = toset(module.db.cluster_members)
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
    data.aws_iam_policy_document.this[each.key].json
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

  name                    = var.opensearch_settings.name
  enviroment              = local.environment
  vpc_id                  = var.vpc_settings.vpc_id
  subnet_ids              = var.opensearch_settings.subnet_ids
  zone_awareness_enabled  = var.opensearch_settings.zone_awareness_enabled
  engine_version          = var.opensearch_settings.engine_version
  instance_type           = var.opensearch_settings.instance_type
  instance_count          = var.opensearch_settings.instance_count
  ebs_volume_size         = var.opensearch_settings.ebs_volume_size
  ebs_iops                = var.opensearch_settings.ebs_iops
  ebs_volume_type         = var.opensearch_settings.ebs_volume_type
  encrypt_at_rest_enabled = var.opensearch_settings.encrypt_at_rest_enabled
  security_groups         = var.opensearch_settings.allowed_security_groups
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = var.tags
}

resource "aws_opensearch_domain_policy" "this" {
  domain_name     = module.opensearch.domain_name
  access_policies = data.aws_iam_policy_document.os_explorer_policy.json
}
