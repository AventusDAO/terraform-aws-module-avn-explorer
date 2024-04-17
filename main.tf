module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.2"

  name               = var.db_settings.name
  engine             = var.db_settings.engine
  engine_version     = var.db_settings.engine_version
  ca_cert_identifier = var.db_settings.ca_cert_identifier
  instances          = var.db_settings.instances

  vpc_id                 = var.vpc_settings.vpc_id
  db_subnet_group_name   = var.db_settings.db_subnet_group_name
  create_db_subnet_group = false
  vpc_security_group_ids = var.db_settings.security_group_ids

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

#
# Setup AWS EKS IAM Role for reading secrets stored in AWS Secret Manager
#
module "eks_iam_role" {
  source  = "cloudposse/eks-iam-role/aws"
  version = "v1.1.0"

  environment                 = var.environment
  name                        = "${var.eks_iam_role_settings.prefix}-${each.value.service_account_name}-sa"
  aws_account_number          = data.aws_caller_identity.current.account_id
  eks_cluster_oidc_issuer_url = var.eks_iam_role_settings.eks_cluster_oidc_issuer_url
  service_account_name        = each.value.service_account_name
  service_account_namespace   = var.eks_iam_role_settings.service_account_namespace
  aws_iam_policy_document = [
    data.aws_iam_policy_document.this[each.key].json
  ]
  tags = var.tags

  for_each = local.explorer_components
}

resource "aws_secretsmanager_secret" "this" {
  name = "${var.secret_manager_settings.prefix}/${each.key}"

  for_each = local.explorer_components

  tags = var.tags
}
