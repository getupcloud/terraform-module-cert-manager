output "config" {
  description = "DNS Provider config"
  value       = lookup(local.output, var.provider_name)
}
