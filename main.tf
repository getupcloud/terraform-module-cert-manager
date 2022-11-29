locals {
  name_prefix = substr("${var.cluster_name}-certmanager", 0, 32)
  output = {
    aws : var.provider_name == "aws" ? module.aws[0] : tomap({})
    #    aks : var.provider_name == "aks" ? module.aks[0] : tomap({})
  }

}

module "aws" {
  count  = var.provider_name == "aws" ? 1 : 0
  source = "./aws"

  cluster_name              = var.cluster_name
  customer_name             = var.customer_name
  hosted_zone_ids           = var.provider_aws.hosted_zone_ids
  cluster_oidc_issuer_url   = var.provider_aws.cluster_oidc_issuer_url
  service_account_namespace = var.provider_aws.service_account_namespace
  service_account_name      = var.provider_aws.service_account_name
  tags                      = var.provider_aws.tags
}

#module "aks" {
#  count  = var.provider_name == "aks" ? 1 : 0
#  source = "./aks"
#}
