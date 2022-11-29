variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "customer_name" {
  description = "customer name"
  type        = string
}

variable "provider_name" {
  description = "Provider where to configure cert-manager resources"
  type        = string

  validation {
    condition     = contains(["aws"], var.provider_name)
    error_message = "Invalid provider name."
  }
}

variable "provider_aws" {
  description = "Config to Route53"
  type = object({
    hosted_zone_ids : list(string)
    cluster_oidc_issuer_url : string
    service_account_namespace : string
    service_account_name : string
    tags : any
  })

  default = {
    hosted_zone_ids : []
    cluster_oidc_issuer_url : ""
    service_account_namespace : "cert-manager"
    service_account_name : "cert-manager"
    tags : {}
  }
}
