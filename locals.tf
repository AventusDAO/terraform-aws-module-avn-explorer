locals {
  explorer_components = {
    archive = {
      service_account_name = "archive"
      enabled              = var.explorer_components.archive.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_archive_db"
        db_username = "explorer_archive"
        avn_node    = ""
        db_password = try(random_password.this["archive"].result, null)
        db_type     = "postgres"
      }
    }
    balances = {
      service_account_name = "balances"
      enabled              = var.explorer_components.balances.enabled
      secrets = {
        db_hostname          = module.db.cluster_endpoint
        db_port              = tostring(module.db.cluster_port)
        db_name              = "explorer_balances_db"
        db_username          = "explorer_balances"
        db_password          = try(random_password.this["balances"].result, null)
        admin_porta_user     = local.additional_credentials_config.explorer_ro.username
        admin_porta_password = try(random_password.credentials["explorer_ro"].result, null)
      }
    }
    fees = {
      service_account_name = "fees"
      enabled              = var.explorer_components.fees.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_fees_db"
        db_username = "explorer_fees"
        db_password = try(random_password.this["fees"].result, null)
      }
    }
    staking = {
      service_account_name = "staking"
      enabled              = var.explorer_components.staking.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_staking_db"
        db_username = "explorer_staking"
        db_password = try(random_password.this["staking"].result, null)
      }
    }
    summary = {
      service_account_name = "summary"
      enabled              = var.explorer_components.summary.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_summary_db"
        db_username = "explorer_summary"
        db_password = try(random_password.this["summary"].result, null)
      }
    }
    tokens = {
      service_account_name = "tokens"
      enabled              = var.explorer_components.tokens.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_tokens_db"
        db_username = "explorer_tokens"
        db_password = try(random_password.this["tokens"].result, null)
      }
    }
    search = {
      service_account_name = "search"
      enabled              = var.explorer_components.search.enabled
      secrets = {
        db_hostname                = module.db.cluster_endpoint
        db_port                    = tostring(module.db.cluster_port)
        db_name                    = "explorer_search_db"
        db_username                = "explorer_search"
        db_password                = try(random_password.this["search"].result, null)
        es_url_search              = module.opensearch.domain_endpoint
        es_blocks_index_search     = "blocks"
        es_extrinsics_index_search = "extrinsics"
        es_events_index_search     = "events"
      }
    }
    search-server = {
      service_account_name = "search-server"
      enabled              = var.explorer_components.search-server.enabled
      secrets = {
        es_url_search              = module.opensearch.domain_endpoint
        es_blocks_index_search     = "blocks"
        es_extrinsics_index_search = "extrinsics"
        es_events_index_search     = "events"
      }
    }
    errors = {
      service_account_name = "errors"
      enabled              = var.explorer_components.errors.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_errors_db"
        db_username = "explorer_errors"
        db_password = try(random_password.this["errors"].result, null)
      }
    }
    nft = {
      service_account_name = "nft"
      enabled              = var.explorer_components.nft.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_nft_db"
        db_username = "explorer_nft"
        db_password = try(random_password.this["nft"].result, null)
      }
    }
    solochain-archive = {
      service_account_name = "solo-archive"
      enabled              = var.explorer_components.solochain-archive.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_solochain_archive_db"
        db_username = "explorer_solochain_archive"
        db_password = try(random_password.this["solochain-archive"].result, null)
        db_type     = "postgres"
        avn_node    = ""
      }
    }
    solochain-search = {
      service_account_name = "solo-search"
      enabled              = var.explorer_components.solochain-search.enabled
      secrets = {
        db_hostname                = module.db.cluster_endpoint
        db_port                    = module.db.cluster_port
        db_name                    = "explorer_solochain_search_db"
        db_username                = "explorer_solochain_search"
        db_password                = try(random_password.this["solochain-search"].result, null)
        es_url_search              = module.opensearch.domain_endpoint
        es_blocks_index_search     = "blocks"
        es_extrinsics_index_search = "extrinsics"
        es_events_index_search     = "events"
      }
    }
    account-monitor = {
      service_account_name = "account-mon"
      enabled              = var.explorer_components.account-monitor.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = tostring(module.db.cluster_port)
        db_name     = "explorer_account_monitor_db"
        db_username = "explorer_account_monitor"
        db_password = try(random_password.this["account-monitor"].result, null)
      }
    }
    nuke = {
      service_account_name = "nuke"
      enabled              = var.explorer_components.nuke.enabled
      secrets = {
        db_hostname = module.db.cluster_endpoint
        db_port     = module.db.cluster_port
      }
    }
  }

  additional_credentials_config = {
    explorer_ro = {
      username = "explorer_ro"
    }
    read_only = {
      username = "readonly"
    }
  }

  enabled_components = {
    for k, v in var.explorer_components : k => k
    if v.enabled
  }
}
