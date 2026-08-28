mock_provider "azapi" {}
mock_provider "azurerm" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  location                            = "eastus"
  name                                = "test-connection"
  resource_group_name                 = "test-resource-group"
  type                                = "ExpressRoute"
  virtual_network_gateway_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-resource-group/providers/Microsoft.Network/virtualNetworkGateways/test-gateway"
  express_route_circuit_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-resource-group/providers/Microsoft.Network/expressRouteCircuits/test-circuit"
  enable_telemetry                    = false
}

run "accepts_null_connection_protocol" {
  command = plan

  variables {
    connection_protocol = null
  }
}

run "rejects_unsupported_connection_protocol" {
  command = plan

  variables {
    connection_protocol = "IKEv3"
  }

  expect_failures = [
    var.connection_protocol,
  ]
}
