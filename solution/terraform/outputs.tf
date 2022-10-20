###############################################################################
#
# Application can be accessed by browsing output of this public ip dns name
#
###############################################################################
output "public_ip_dns_name" {
  value       = azurerm_public_ip.base.*.fqdn
  description = "A public ip address where application can be browsed"
}

