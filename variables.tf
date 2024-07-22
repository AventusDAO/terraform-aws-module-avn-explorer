variable "environment" {
  description = "environment name"
  type        = string
}

variable "monitoring_sns_topic" {
  description = "Monitoring SNS Topic list"
  type        = list(string)
  default     = null
}

variable "vpc_settings" {
  description = "VPC Settings"
  type = object({
    vpc_id = string
    }
  )
}

variable "explorer_components" {
  description = "AvN Explorer Components"
  type = object(
    {
      archive = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      balances = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      fees = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      staking = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      summary = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      tokens = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      search = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      search-server = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      errors = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      nft = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      solochain-archive = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      solochain-search = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      account-monitor = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
      nuke = optional(
        object({
          enabled = optional(bool)
        }),
        {
          enabled = true
        }
      )
  })
}

variable "db_settings" {
  description = "RDS db settings"
  type = object({
    db_subnet_group_name = string
    name                 = optional(string, "avn-explorer")
    create_cluster       = optional(bool, true)
    engine               = optional(string, "aurora-postgresql")
    engine_version       = optional(string, "14.10")
    ca_cert_identifier   = optional(string, "rds-ca-rsa2048-g1")
    family               = optional(string, "aurora-postgresql14")
    security_group_ids   = list(string)
    instances = optional(any,
      {
        1 = {
          instance_class      = "db.t4g.medium"
          publicly_accessible = false
        }
      }
    )
    iam_database_authentication_enabled   = optional(bool, true)
    create_random_password                = optional(bool, true)
    apply_immediately                     = optional(bool, true)
    skip_final_snapshot                   = optional(bool, false)
    performance_insights_enabled          = optional(bool, true)
    performance_insights_retention_period = optional(number, 7)
    create_monitoring_role                = optional(bool, true)
    monitoring_interval                   = optional(number, 60)
    db_cluster_parameter_group_parameters = optional(list(any), [
      {

        name         = "log_min_duration_statement"
        value        = 4000
        apply_method = "immediate"
        }, {
        name         = "rds.force_ssl"
        value        = 0
        apply_method = "immediate"
      }
    ])
    db_parameter_group_parameters = optional(list(any), [
      {
        name         = "log_min_duration_statement"
        value        = 4000
        apply_method = "immediate"
      }
    ])
    }
  )
}

variable "opensearch_settings" {
  description = "Opensearch Settings"
  type = object({
    enabled                 = optional(bool, true)
    name                    = optional(string, "explorer")
    subnet_ids              = list(string)
    zone_awareness_enabled  = optional(bool, false)
    engine_version          = optional(string, "OpenSearch_2.3")
    instance_type           = optional(string, "m6g.large.search")
    instance_count          = optional(number, 1)
    ebs_volume_size         = optional(number, 100)
    ebs_iops                = optional(number, 3000)
    ebs_volume_type         = optional(string, "gp3")
    encrypt_at_rest_enabled = optional(bool, true)
    security_groups         = optional(list(string), [])
  })

  default = {
    enabled                 = true
    name                    = "explorer"
    subnet_ids              = []
    zone_awareness_enabled  = false
    engine_version          = "OpenSearch_2.3"
    instance_type           = "m6g.large.search"
    instance_count          = 1
    ebs_volume_size         = 100
    ebs_iops                = 3000
    ebs_volume_type         = "gp3"
    encrypt_at_rest_enabled = true
    security_groups         = []
  }
}

variable "eks_iam_role_settings" {
  description = "EKS IAM Role Settings"
  type = object({
    prefix                      = optional(string, "avn-explorer")
    eks_cluster_oidc_issuer_url = string
    service_account_namespace   = string
  })
}
variable "secret_manager_settings" {
  description = "AWS Secret Manager prefix"
  type = object({
    prefix                  = optional(string, "avn-explorer")
    recovery_window_in_days = optional(number, 30)
    kms_key_id              = optional(string, null)
  })

  default = {
    prefix                  = "avn-explorer"
    recovery_window_in_days = 30
    kms_key_id              = null
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
