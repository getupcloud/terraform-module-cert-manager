variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "customer_name" {
  description = "customer name"
  type        = string
}

variable "dns_provider" {
  description = "Provider to give control to cert-manager"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "aws"], var.dns_provider)
    error_message = "Invalid dns_provider name.
  }
}

variable "dns_provider_aws" {
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
