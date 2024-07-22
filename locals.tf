locals {
  explorer_components = {
    archive = {
      service_account_name = "archive"
      enabled              = var.explorer_components.archive.enabled
    }
    balances = {
      service_account_name = "balances"
      enabled              = var.explorer_components.balances.enabled
    }
    fees = {
      service_account_name = "fees"
      enabled              = var.explorer_components.fees.enabled
    }
    staking = {
      service_account_name = "staking"
      enabled              = var.explorer_components.staking.enabled
    }
    summary = {
      service_account_name = "summary"
      enabled              = var.explorer_components.summary.enabled
    }
    tokens = {
      service_account_name = "tokens"
      enabled              = var.explorer_components.tokens.enabled
    }
    search = {
      service_account_name = "search"
      enabled              = var.explorer_components.search.enabled
    }
    search-server = {
      service_account_name = "search-server"
      enabled              = var.explorer_components.search-server.enabled
    }
    errors = {
      service_account_name = "errors"
      enabled              = var.explorer_components.errors.enabled
    }
    nft = {
      service_account_name = "nft"
      enabled              = var.explorer_components.nft.enabled
    }
    solochain-archive = {
      service_account_name = "solo-archive"
      enabled              = var.explorer_components.solochain-archive.enabled
    }
    solochain-search = {
      service_account_name = "solo-search"
      enabled              = var.explorer_components.solochain-search.enabled
    }
    account-monitor = {
      service_account_name = "account-mon"
      enabled              = var.explorer_components.account-monitor.enabled
    }
    nuke = {
      service_account_name = "nuke"
      enabled              = var.explorer_components.nuke.enabled
    }
  }
}
