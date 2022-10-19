##################################################################
#
# Application can be accessed by browsing output of this public ip
#
##################################################################
output "public_ip" {
  value       = azurerm_public_ip.base.ip_address
  description = "A public ip address where application can be browsed"
}

