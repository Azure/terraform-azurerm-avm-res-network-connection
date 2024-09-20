# TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
resource "azurerm_virtual_network_gateway_connection" "onpremise" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                       = var.type
  shared_key = var.shared_key
  virtual_network_gateway_id = var.virtual_network_gateway_id

  #Non Required
  local_network_gateway_id   = var.local_network_gateway_id

 
  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy 
    content {
      sa_lifetime = ipsec_policy.value.sa_lifetime
      sa_datasize = ipsec_policy.value.sa_datasize
      ipsec_encryption = ipsec_policy.value.ipsec_encryption
      ipsec_integrity = ipsec_policy.value.ipsec_integrity
      ike_encryption = ipsec_policy.value.ike_encryption
      ike_integrity = ipsec_policy.value.ike_integrity
      dh_group = ipsec_policy.value.dh_group
      pfs_group = ipsec_policy.value.pfs_group
    }
    ## If this was an object, remove dynamic, for_each and content
  }
}



# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_MY_RESOURCE.this.id # TODO: Replace with your azurerm resource name
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_resource_group.TODO.id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}
