variable "environment" {
  description = "environment name"
  type        = string
}

variable "vpc_settings" {
  description = "VPC Settings"
  type = object({
    vpc_id = string
    }
  )
}

variable "db_settings" {
  description = "RDS db settings"
  type = object({
    db_subnet_group_name = string
    name                 = optional(string, "avn-explorer")
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
    prefix = optional(string, "avn-explorer")
  })
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
