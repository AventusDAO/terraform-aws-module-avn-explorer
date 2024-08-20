module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.7.1"

  name                        = var.db_settings.name
  create_cluster              = var.db_settings.create_cluster
  engine                      = var.db_settings.engine
  engine_version              = var.db_settings.engine_version
  ca_cert_identifier          = var.db_settings.ca_cert_identifier
  instances                   = var.db_settings.instances
  kms_key_id                  = var.db_settings.kms_key_id
  allow_major_version_upgrade = var.db_settings.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.db_settings.auto_minor_version_upgrade

  vpc_id                  = var.vpc_settings.vpc_id
  db_subnet_group_name    = var.db_settings.db_subnet_group_name
  create_db_subnet_group  = false
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

  // db_cluster_parameter_group_name = var.allow_major_version_upgrade && var.db_settings.major_migration_upgrade != null ? aws_rds_cluster_parameter_group.green[0].name : aws_db_parameter_group.blue.name
  // db_parameter_group_name        = var.allow_major_version_upgrade && var.db_settings.major_migration_upgrade != null ? aws_db_parameter_group.green[0].name : aws_db_parameter_group.blue.name

  enabled_cloudwatch_logs_exports       = ["postgresql"]
  performance_insights_enabled          = var.db_settings.performance_insights_enabled
  performance_insights_retention_period = var.db_settings.performance_insights_retention_period
  create_monitoring_role                = var.db_settings.create_monitoring_role
  monitoring_interval                   = var.db_settings.monitoring_interval

  tags = var.tags
}

################################################################################
# Cluster Parameter Group
################################################################################

resource "aws_rds_cluster_parameter_group" "blue" {
  name        = local.db_parameter_group_name
  description = "${var.db_settings.name} cluster parameter group"
  family      = var.db_settings.family

  dynamic "parameter" {
    for_each = var.db_settings.db_cluster_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

################################################################################
# DB Parameter Group
################################################################################

resource "aws_db_parameter_group" "blue" {
  name        = local.db_parameter_group_name
  description = "${var.db_settings.name} DB parameter group"
  family      = var.db_settings.family

  dynamic "parameter" {
    for_each = var.db_settings.db_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

################################################################################
# Cluster Parameter Group
################################################################################

resource "aws_rds_cluster_parameter_group" "green" {
  count = var.allow_major_version_upgrade && major_migration_upgrade != null ? 1 : 0

  name        = local.db_parameter_group_name
  description = "${var.db_settings.name} cluster parameter group"
  family      = var.db_settings.major_version_upgrade

  dynamic "parameter" {
    for_each = var.db_settings.db_cluster_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

################################################################################
# DB Parameter Group
################################################################################

resource "aws_db_parameter_group" "green" {
  count = var.allow_major_version_upgrade && major_migration_upgrade != null ? 1 : 0

  name        = local.db_parameter_group_name
  description = "${var.db_settings.name} DB parameter group"
  family      = var.db_settings.major_version_upgrade

  dynamic "parameter" {
    for_each = var.db_settings.db_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
