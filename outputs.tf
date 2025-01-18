output "resource_id" {
  description = "The full Azure resource ID of the Virtual Network Gateway Connection."
  value       = azurerm_virtual_network_gateway_connection.this.id
}
