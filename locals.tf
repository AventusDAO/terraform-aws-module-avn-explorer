locals {
  explorer_components = {
    archive = {
      service_account_name = "archive"
      enabled              = var.explorer_components.archive.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_archive_db"
        db_username = "explorer_archive"
        avn_node    = ""
        db_password = ""
        db_type     = "postgres"
      }
    }
    balances = {
      service_account_name = "balances"
      enabled              = var.explorer_components.balances.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_balances_db"
        db_username = "explorer_balances"
        db_password = ""
      }
    }
    fees = {
      service_account_name = "fees"
      enabled              = var.explorer_components.fees.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_fees_db"
        db_username = "explorer_fees"
        db_password = ""
      }
    }
    staking = {
      service_account_name = "staking"
      enabled              = var.explorer_components.staking.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_staking_db"
        db_username = "explorer_staking"
        db_password = ""
      }
    }
    summary = {
      service_account_name = "summary"
      enabled              = var.explorer_components.summary.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_summary_db"
        db_username = "explorer_summary"
        db_password = ""
      }
    }
    tokens = {
      service_account_name = "tokens"
      enabled              = var.explorer_components.tokens.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_tokens_db"
        db_username = "explorer_tokens"
        db_password = ""
      }
    }
    search = {
      service_account_name = "search"
      enabled              = var.explorer_components.search.enabled
      secrets = {
        db_hostname                = module.rds.cluster_endpoint
        db_port                    = module.rds.cluster_port
        db_name                    = "explorer_search_db"
        db_username                = "explorer_search"
        db_password                = ""
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
        es_url_search              = module.opensearch.opensearch_endpoint
        es_blocks_index_search     = "blocks"
        es_extrinsics_index_search = "extrinsics"
        es_events_index_search     = "events"
      }
    }
    errors = {
      service_account_name = "errors"
      enabled              = var.explorer_components.errors.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_errors_db"
        db_username = "explorer_errors"
        db_password = ""
      }
    }
    nft = {
      service_account_name = "nft"
      enabled              = var.explorer_components.nft.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_nft_db"
        db_username = "explorer_nft"
        db_password = ""
      }
    }
    solochain-archive = {
      service_account_name = "solo-archive"
      enabled              = var.explorer_components.solochain-archive.enabled
      secrets = {
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_solochain_archive_db"
        db_username = "explorer_solochain_archive"
        db_password = ""
        db_type     = "postgres"
        avn_node    = ""
      }
    }
    solochain-search = {
      service_account_name = "solo-search"
      enabled              = var.explorer_components.solochain-search.enabled
      secrets = {
        db_hostname                = module.rds.cluster_endpoint
        db_port                    = module.rds.cluster_port
        db_name                    = "explorer_solochain_search_db"
        db_username                = "explorer_solochain_search"
        db_password                = ""
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
        db_hostname = module.rds.cluster_endpoint
        db_port     = module.rds.cluster_port
        db_name     = "explorer_account_monitor_db"
        db_username = "explorer_account_monitor"
        db_password = ""
      }
    }
    nuke = {
      service_account_name = "nuke"
      enabled              = var.explorer_components.nuke.enabled
    }
  }
}
