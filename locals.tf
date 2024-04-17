locals {
  explorer_components = {
    archive = {
      service_account_name = "archive"
      secret_manager_arns  = []
    }
    balances = {
      service_account_name = "balances"
      secret_manager_arns  = []
    }
    fees = {
      service_account_name = "fees"
      secret_manager_arns  = []
    }
    staking = {
      service_account_name = "staking"
      secret_manager_arns  = []
    }
    summary = {
      service_account_name = "summary"
      secret_manager_arns  = []
    }
    tokens = {
      service_account_name = "tokens"
      secret_manager_arns  = []
    }
    search = {
      service_account_name = "search"
      secret_manager_arns  = []
    }
    search-server = {
      service_account_name = "search-server"
      secret_manager_arns  = []
    }
    errors = {
      service_account_name = "errors"
      secret_manager_arns  = []
    }
    nft = {
      service_account_name = "nft"
      secret_manager_arns  = []
    }
    solochain-archive = {
      service_account_name = "solo-archive"
      secret_manager_arns  = []
    }
    solochain-search = {
      service_account_name = "solo-search"
      secret_manager_arns  = []
    }
    account-monitor = {
      service_account_name = "account-mon"
      secret_manager_arns  = []
    }
    nuke = {
      service_account_name = "nuke"
      secret_manager_arns = [
        aws_secretsmanager_secret.this["archive"].arn,
        aws_secretsmanager_secret.this["balances"].arn,
        aws_secretsmanager_secret.this["fees"].arn,
        aws_secretsmanager_secret.this["staking"].arn,
        aws_secretsmanager_secret.this["summary"].arn,
        aws_secretsmanager_secret.this["tokens"].arn,
        aws_secretsmanager_secret.this["search"].arn,
        aws_secretsmanager_secret.this["search-server"].arn,
        aws_secretsmanager_secret.this["solochain-archive"].arn,
        aws_secretsmanager_secret.this["solochain-search"].arn,
        aws_secretsmanager_secret.this["errors"].arn,
        aws_secretsmanager_secret.this["account-monitor"].arn,
        aws_secretsmanager_secret.this["nft"].arn,
      ]
    }
  }
}
