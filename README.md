<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds-aurora/aws | 7.6.2 |
| <a name="module_eks_iam_role"></a> [eks\_iam\_role](#module\_eks\_iam\_role) | cloudposse/eks-iam-role/aws | v2.1.1 |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | git@github.com:Aventus-Network-Services/terraform-aws-rds-monitoring | v0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_settings"></a> [db\_settings](#input\_db\_settings) | RDS db settings | <pre>object({<br>    db_subnet_group_name = string<br>    name                 = optional(string, "avn-explorer")<br>    create_cluster       = optional(bool, true)<br>    engine               = optional(string, "aurora-postgresql")<br>    engine_version       = optional(string, "14.10")<br>    ca_cert_identifier   = optional(string, "rds-ca-rsa2048-g1")<br>    family               = optional(string, "aurora-postgresql14")<br>    security_group_ids   = list(string)<br>    instances = optional(any,<br>      {<br>        1 = {<br>          instance_class      = "db.t4g.medium"<br>          publicly_accessible = false<br>        }<br>      }<br>    )<br>    iam_database_authentication_enabled   = optional(bool, true)<br>    create_random_password                = optional(bool, true)<br>    apply_immediately                     = optional(bool, true)<br>    skip_final_snapshot                   = optional(bool, false)<br>    performance_insights_enabled          = optional(bool, true)<br>    performance_insights_retention_period = optional(number, 7)<br>    create_monitoring_role                = optional(bool, true)<br>    monitoring_interval                   = optional(number, 60)<br>    db_cluster_parameter_group_parameters = optional(list(any), [<br>      {<br><br>        name         = "log_min_duration_statement"<br>        value        = 4000<br>        apply_method = "immediate"<br>        }, {<br>        name         = "rds.force_ssl"<br>        value        = 0<br>        apply_method = "immediate"<br>      }<br>    ])<br>    db_parameter_group_parameters = optional(list(any), [<br>      {<br>        name         = "log_min_duration_statement"<br>        value        = 4000<br>        apply_method = "immediate"<br>      }<br>    ])<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_eks_iam_role_settings"></a> [eks\_iam\_role\_settings](#input\_eks\_iam\_role\_settings) | EKS IAM Role Settings | <pre>object({<br>    prefix                      = optional(string, "avn-explorer")<br>    eks_cluster_oidc_issuer_url = string<br>    service_account_namespace   = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment name | `string` | n/a | yes |
| <a name="input_monitoring_sns_topic"></a> [monitoring\_sns\_topic](#input\_monitoring\_sns\_topic) | Monitoring SNS Topic list | `list(string)` | `[]` | no |
| <a name="input_secret_manager_settings"></a> [secret\_manager\_settings](#input\_secret\_manager\_settings) | AWS Secret Manager prefix | <pre>object({<br>    prefix                  = optional(string, "avn-explorer")<br>    recovery_window_in_days = optional(number, 30)<br>    kms_key_id              = optional(string, null)<br>  })</pre> | <pre>{<br>  "kms_key_id": null,<br>  "prefix": "avn-explorer",<br>  "recovery_window_in_days": 30<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_settings"></a> [vpc\_settings](#input\_vpc\_settings) | VPC Settings | <pre>object({<br>    vpc_id = string<br>    }<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_explorer_components"></a> [explorer\_components](#output\_explorer\_components) | Explorer components settings for EKS |
<!-- END_TF_DOCS -->
