terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

resource "azurerm_virtual_network" "this" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  name                = module.naming.virtual_network.name_unique
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "gateway_subnet" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
}

resource "azurerm_local_network_gateway" "onpremise" {
  location            = azurerm_resource_group.this.location
  name                = "onpremise"
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.1.1.0/24"]
  gateway_address     = "168.62.225.23"
}

resource "azurerm_public_ip" "this" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.this.location
  name                = "${module.naming.public_ip.name_unique}-1"
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_virtual_network_gateway" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.virtual_network_gateway.name_unique
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "VpnGw1AZ"
  type                = "Vpn"
  active_active       = true
  enable_bgp          = false
  vpn_type            = "RouteBased"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.this.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-res-network-connection/azurerm"
  # ...
  location                            = azurerm_resource_group.this.location
  name                                = module.naming.virtual_network_gateway_connection.name_unique # TODO update with module.naming.<RESOURCE_TYPE>.name_unique
  resource_group_name                 = azurerm_resource_group.this.name
  type                                = "IPsec"
  shared_key                          = "abc123"
  virtual_network_gateway_resource_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_resource_id   = azurerm_local_network_gateway.onpremise.id
  enable_telemetry                    = var.enable_telemetry # see variables.tf
}
