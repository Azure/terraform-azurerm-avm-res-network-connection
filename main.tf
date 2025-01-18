# TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
resource "azurerm_virtual_network_gateway_connection" "this" {
  location                           = var.location
  name                               = var.name
  resource_group_name                = var.resource_group_name
  type                               = var.type
  virtual_network_gateway_id         = var.virtual_network_gateway_resource_id
  authorization_key                  = var.authorization_key
  connection_mode                    = var.connection_mode
  connection_protocol                = var.connection_protocol
  dpd_timeout_seconds                = var.dpd_timeout_seconds
  egress_nat_rule_ids                = var.egress_nat_rule_resource_ids
  enable_bgp                         = var.enable_bgp
  express_route_circuit_id           = var.express_route_circuit_resource_id
  express_route_gateway_bypass       = var.express_route_gateway_bypass
  ingress_nat_rule_ids               = var.ingress_nat_rule_resource_ids
  local_azure_ip_address_enabled     = var.local_azure_ip_address_enabled
  local_network_gateway_id           = var.local_network_gateway_resource_id
  private_link_fast_path_enabled     = var.private_link_fast_path_enabled
  routing_weight                     = var.routing_weight
  shared_key                         = var.shared_key
  tags                               = var.tags
  use_policy_based_traffic_selectors = var.use_policy_based_traffic_selectors

  dynamic "custom_bgp_addresses" {
    for_each = var.custom_bgp_addresses == null ? [] : ["custom_bgp_addresses"]

    content {
      primary   = var.custom_bgp_addresses.primary
      secondary = var.custom_bgp_addresses.secondary
    }
  }
  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy

    content {
      dh_group         = ipsec_policy.value.dh_group
      ike_encryption   = ipsec_policy.value.ike_encryption
      ike_integrity    = ipsec_policy.value.ike_integrity
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity  = ipsec_policy.value.ipsec_integrity
      pfs_group        = ipsec_policy.value.pfs_group
      sa_datasize      = ipsec_policy.value.sa_datasize
      sa_lifetime      = ipsec_policy.value.sa_lifetime
    }
  }
  dynamic "traffic_selector_policy" {
    for_each = var.traffic_selector_policy

    content {
      local_address_cidrs  = traffic_selector_policy.value.local_address_cidrs
      remote_address_cidrs = traffic_selector_policy.value.remote_address_cidrs
    }
  }
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_virtual_network_gateway_connection.this.id # TODO: Replace with your azurerm resource name
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}
