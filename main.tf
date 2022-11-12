locals {
  name_prefix = substr("${var.cluster_name}-certmanager", 0, 32)
  output = {
    aws : var.dns_provider == "aws" ? module.aws[0] : tomap({})
    aks : var.dns_provider == "aks" ? module.aks[0] : tomap({})
  }

}

module "aws" {
  count  = var.dns_provider == "aws" ? 1 : 0
  source = "./aws"

  cluster_name              = var.cluster_name
  customer_name             = var.customer_name
  hosted_zone_ids           = var.dns_provider_aws.hosted_zone_ids
  cluster_oidc_issuer_url   = var.dns_provider_aws.cluster_oidc_issuer_url
  service_account_namespace = var.dns_provider_aws.service_account_namespace
  service_account_name      = var.dns_provider_aws.service_account_name
  tags                      = var.dns_provider_aws.tags
}

module "aks" {
  count  = var.dns_provider == "aks" ? 1 : 0
  source = "./aks"
}
