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
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds-aurora/aws | 7.7.1 |
| <a name="module_eks_iam_role"></a> [eks\_iam\_role](#module\_eks\_iam\_role) | cloudposse/eks-iam-role/aws | v2.1.1 |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | git@github.com:Aventus-Network-Services/terraform-aws-rds-monitoring | v0.1.0 |
| <a name="module_opensearch"></a> [opensearch](#module\_opensearch) | git@github.com:Aventus-Network-Services/terraform-aws-module-opensearch.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_opensearch_domain_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain_policy) | resource |
| [aws_secretsmanager_secret.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.os_explorer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_settings"></a> [db\_settings](#input\_db\_settings) | RDS db settings | <pre>object({<br>    db_subnet_group_name    = string<br>    name                    = optional(string, "avn-explorer")<br>    create_cluster          = optional(bool, true)<br>    engine                  = optional(string, "aurora-postgresql")<br>    engine_version          = optional(string, "16.2")<br>    ca_cert_identifier      = optional(string, "rds-ca-rsa2048-g1")<br>    family                  = optional(string, "aurora-postgresql14")<br>    allowed_security_groups = optional(list(string), [])<br>    allowed_cidr_blocks     = optional(list(string), [])<br>    instances = optional(any,<br>      {<br>        1 = {<br>          instance_class      = "db.t4g.medium"<br>          publicly_accessible = false<br>        }<br>      }<br>    )<br>    iam_database_authentication_enabled   = optional(bool, true)<br>    create_random_password                = optional(bool, true)<br>    apply_immediately                     = optional(bool, true)<br>    skip_final_snapshot                   = optional(bool, false)<br>    performance_insights_enabled          = optional(bool, true)<br>    performance_insights_retention_period = optional(number, 7)<br>    create_monitoring_role                = optional(bool, true)<br>    monitoring_interval                   = optional(number, 60)<br>    db_cluster_parameter_group_parameters = optional(list(any), [<br>      {<br><br>        name         = "log_min_duration_statement"<br>        value        = 4000<br>        apply_method = "immediate"<br>        }, {<br>        name         = "rds.force_ssl"<br>        value        = 0<br>        apply_method = "immediate"<br>      }<br>    ])<br>    db_parameter_group_parameters = optional(list(any), [<br>      {<br>        name         = "log_min_duration_statement"<br>        value        = 4000<br>        apply_method = "immediate"<br>      }<br>    ])<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_eks_iam_role_settings"></a> [eks\_iam\_role\_settings](#input\_eks\_iam\_role\_settings) | EKS IAM Role Settings | <pre>object({<br>    prefix                      = optional(string, "avn-explorer")<br>    eks_cluster_oidc_issuer_url = string<br>    service_account_namespace   = string<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment name | `string` | n/a | yes |
| <a name="input_explorer_components"></a> [explorer\_components](#input\_explorer\_components) | AvN Explorer Components | <pre>object(<br>    {<br>      archive = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      balances = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      fees = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      staking = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      summary = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      tokens = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      search = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      search-server = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      errors = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      nft = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      solochain-archive = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      solochain-search = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      account-monitor = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>      nuke = optional(<br>        object({<br>          enabled = optional(bool)<br>        }),<br>        {<br>          enabled = true<br>        }<br>      )<br>  })</pre> | n/a | yes |
| <a name="input_monitoring_sns_topic"></a> [monitoring\_sns\_topic](#input\_monitoring\_sns\_topic) | Monitoring SNS Topic list | `list(string)` | `null` | no |
| <a name="input_opensearch_settings"></a> [opensearch\_settings](#input\_opensearch\_settings) | Opensearch Settings | <pre>object({<br>    enabled                 = optional(bool, true)<br>    name                    = optional(string, "explorer")<br>    subnet_ids              = list(string)<br>    zone_awareness_enabled  = optional(bool, false)<br>    engine_version          = optional(string, "OpenSearch_2.3")<br>    instance_type           = optional(string, "m6g.large.search")<br>    instance_count          = optional(number, 1)<br>    ebs_volume_size         = optional(number, 100)<br>    ebs_iops                = optional(number, 3000)<br>    ebs_volume_type         = optional(string, "gp3")<br>    encrypt_at_rest_enabled = optional(bool, true)<br>    allowed_security_groups = optional(list(string), [])<br>  })</pre> | <pre>{<br>  "allowed_security_groups": [],<br>  "ebs_iops": 3000,<br>  "ebs_volume_size": 100,<br>  "ebs_volume_type": "gp3",<br>  "enabled": true,<br>  "encrypt_at_rest_enabled": true,<br>  "engine_version": "OpenSearch_2.3",<br>  "instance_count": 1,<br>  "instance_type": "m6g.large.search",<br>  "name": "explorer",<br>  "subnet_ids": [],<br>  "zone_awareness_enabled": false<br>}</pre> | no |
| <a name="input_secret_manager_settings"></a> [secret\_manager\_settings](#input\_secret\_manager\_settings) | AWS Secret Manager prefix | <pre>object({<br>    prefix                  = optional(string, "avn-explorer")<br>    recovery_window_in_days = optional(number, 30)<br>    kms_key_id              = optional(string, null)<br>  })</pre> | <pre>{<br>  "kms_key_id": null,<br>  "prefix": "avn-explorer",<br>  "recovery_window_in_days": 30<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_settings"></a> [vpc\_settings](#input\_vpc\_settings) | VPC Settings | <pre>object({<br>    vpc_id = string<br>    }<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_explorer_components"></a> [explorer\_components](#output\_explorer\_components) | Explorer components settings for EKS |
<!-- END_TF_DOCS -->
