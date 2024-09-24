variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "Connection name"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "shared_key" {
  type        = string
  description = "value of the shared key for both ends of the connection."
}

variable "type" {
  type        = string
  description = "The type of connection. Must be one of 'Vnet2Vnet', 'ExpressRoute', or 'IPsec'."

  validation {
    condition     = contains(["Vnet2Vnet", "ExpressRoute", "IPsec"], var.type)
    error_message = "The type must be one of 'Vnet2Vnet', 'ExpressRoute', or 'IPsec'."
  }
}

variable "virtual_network_gateway_resource_id" {
  type        = string
  description = "The ID of the Azure Virtual Network Gateway to connect to."
}

variable "authorization_key" {
  type        = string
  default     = null
  description = "The authorization key for the connection. This field is required only if the type is an `ExpressRoute` connection"
}

variable "connection_mode" {
  type        = string
  default     = "Default"
  description = "Possible values are Default, InitiatorOnly and ResponderOnly. Defaults to Default"

  validation {
    condition     = contains(["Default", "InitiatorOnly", "ResponderOnly"], var.connection_mode)
    error_message = "The type must be one of 'Default', 'InitiatorOnly', or 'ResponderOnly'."
  }
}

variable "connection_protocol" {
  type        = string
  default     = "IKEv2"
  description = "Possible values are `IKEv1` and `IKEv2`. Defaults to `IKEv2`. Changing this forces a new resource to be created. -> Note: Only valid for IPSec connections on virtual network gateways with SKU `VpnGw1`, `VpnGw2`, `VpnGw3`, `VpnGw1AZ`, `VpnGw2AZ` or `VpnGw3AZ`."

  validation {
    condition     = contains(["IKEv1", "IKEv2"], var.connection_protocol)
    error_message = "The type must be one of 'IKEv1, 'IIKEv2'"
  }
}

variable "custom_bgp_addresses" {
  type = object({
    primary   = string
    secondary = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Custom APIPA Adresses for BGP

- `primary` - (Required) - A single IP address that is part of the `azurerm_virtual_network_gateway` ip_configuration (first one)
- `secondary` - (Optional) - A single IP address that is part of the `azurerm_virtual_network_gateway` ip_configuration (second one). Configure in an Active/Active Gateway setting.
DESCRIPTION
}

variable "dpd_timeout_seconds" {
  type        = string
  default     = null
  description = "The dead peer detection timeout of this connection in seconds. Changing this forces a new resource to be created."
}

variable "egress_nat_rule_resource_ids" {
  type        = list(string)
  default     = null
  description = "A list of the egress NAT Rule Ids."
}

variable "enable_bgp" {
  type        = bool
  default     = false
  description = "If true, BGP (Border Gateway Protocol) is enabled for this connection. Defaults to `false`."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetry.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "express_route_circuit_resource_id" {
  type        = string
  default     = null
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection (i.e. when `type` is `ExpressRoute`). The Express Route Circuit can be in the same or in a different subscription. Changing this forces a new resource to be created."
}

variable "express_route_gateway_bypass" {
  type        = bool
  default     = null
  description = "If `true`, data packets will bypass ExpressRoute Gateway for data forwarding This is only valid for ExpressRoute connections"
}

variable "ingress_nat_rule_resource_ids" {
  type        = list(string)
  default     = null
  description = "A list of the ingress NAT Rule Ids."
}

variable "ipsec_policy" {
  type = map(object({
    dh_group         = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_datasize      = optional(string)
    sa_lifetime      = optional(string)

  }))
  default     = {}
  description = <<DESCRIPTION
CIDR blocks for traffic selectors

-  `dh_group `              - (Required) - The DH group used in IKE phase 1 for initial SA. Valid options are `DHGroup1`, `DHGroup14`, `DHGroup2`, `DHGroup2048`, `DHGroup24`, `ECP256`, `ECP384`, or `None`.
-  `ike_encryption`         - (Required) - The IKE encryption algorithm. Valid options are `AES128`, `AES192`, `AES256`, `DES`, `DES3`, `GCMAES128`, or `GCMAES256`.
-  `ike_integrity`          - (Required) - The IKE integrity algorithm. Valid options are `GCMAES128`, `GCMAES256`, `MD5`, `SHA1`, `SHA256`, or `SHA384`.
-  `ipsec_encryption`       - (Required) - The IPSec encryption algorithm. Valid options are `AES128`, `AES192`, `AES256`, `DES`, `DES3`, `GCMAES128`, `GCMAES192`, `GCMAES256`, or `None`.
-  `ipsec_integrity`        - (Required) - The IPSec integrity algorithm. Valid options are `GCMAES128`, `GCMAES192`, `GCMAES256`, `MD5`, `SHA1`, or `SHA256`.
-  `pfs_group`              - (Required) - The DH group used in IKE phase 2 for new child SA. Valid options are `ECP256`, `ECP384`, `PFS1`, `PFS14`, `PFS2`, `PFS2048`, `PFS24`, `PFSMM`, or `None`.
-  `sa_datasize`            - (Optional) - The IPSec SA payload size in KB. Must be at least `1024` KB. Defaults to `102400000` KB.
-  `sa_lifetime`            - (Optional) - The IPSec SA lifetime in seconds. Must be at least `300` seconds. Defaults to `27000` seconds.

DESCRIPTION
}

variable "local_azure_ip_address_enabled" {
  type        = bool
  default     = null
  description = "Use private local Azure IP for the connection. Changing this forces a new resource to be created."
}

variable "local_network_gateway_resource_id" {
  type        = string
  default     = null
  description = "The ID of the Azure Local Network Gateway to connect to when creating a Site-to-Site connection."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "private_link_fast_path_enabled" {
  type        = bool
  default     = false
  description = "Bypass the Express Route gateway when accessing private-links. When enabled `express_route_gateway_bypass` must be set to `true`.  Defaults to `false`."
}

variable "routing_weight" {
  type        = number
  default     = null
  description = "The routing weight. Defaults to 10"
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "traffic_selector_policy" {
  type = map(object({
    local_address_cidrs  = list(string)
    remote_address_cidrs = list(string)
  }))
  default     = {}
  description = <<DESCRIPTION
CIDR blocks for traffic selectors

- `local_address_cidrs` - Required - List of local address CIDRs.
- `remote_address_cidrs` - Required - List of Remote Address CIDRs.
DESCRIPTION
}

variable "use_policy_based_traffic_selectors" {
  type        = bool
  default     = null
  description = "If true, policy-based traffic selectors are enabled for this connection. Enabling policy-based traffic selectors requires an ipsec_policy block."
}
