variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "customer_name" {
  description = "customer name"
  type        = string
}

variable "hosted_zone_ids" {
  description = "AWS Route53 Hosted Zone ID to certmanager automatically handle"
  type        = list(string)

  validation {
    condition     = length(var.hosted_zone_ids) > 0
    error_message = "The hosted_zone_id value must not be empty."
  }
}

variable "cluster_oidc_issuer_url" {
  description = "URL of the OIDC Provider from the EKS cluster"
  type        = string
}

variable "service_account_namespace" {
  description = "Namespace of ServiceAccount for cert-manager"
  default     = "cert-manager"
}

variable "service_account_name" {
  description = "ServiceAccount name for cert-manager"
  default     = "cert-manager"
}

variable "tags" {
  description = "AWS tags to apply to resources"
  type        = any
  default     = {}
}
