output "explorer_components" {
  description = "Explorer components settings for EKS"
  value = tomap({
    for k, v in local.explorer_components : k => {
      service_account_name      = module.eks_iam_role[k].service_account_name
      service_account_namespace = module.eks_iam_role[k].service_account_namespace
      service_account_role_arn  = module.eks_iam_role[k].service_account_role_arn
      service_account_role_name = module.eks_iam_role[k].service_account_role_name
    }
    if v.enabled
  })
}
