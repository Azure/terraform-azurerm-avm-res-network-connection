<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-network-connection

This the AVM module that creates a Virtual Network Gateway Connection.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Connection name

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

### <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key)

Description: value of the shared key for both ends of the connection.

Type: `string`

### <a name="input_type"></a> [type](#input\_type)

Description: The type of connection. Must be one of 'Vnet2Vnet', 'ExpressRoute', or 'IPsec'.

Type: `string`

### <a name="input_virtual_network_gateway_id"></a> [virtual\_network\_gateway\_id](#input\_virtual\_network\_gateway\_id)

Description: The ID of the Azure Virtual Network Gateway to connect to.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_authorization_key"></a> [authorization\_key](#input\_authorization\_key)

Description: The authorization key for the connection. This field is required only if the type is an ExpressRoute connection

Type: `string`

Default: `null`

### <a name="input_connection_mode"></a> [connection\_mode](#input\_connection\_mode)

Description: Possible values are Default, InitiatorOnly and ResponderOnly. Defaults to Default

Type: `string`

Default: `"Default"`

### <a name="input_connection_protocol"></a> [connection\_protocol](#input\_connection\_protocol)

Description: Possible values are IKEv1 and IKEv2, values are IKEv1 and IKEv2. Defaults to IKEv2.

Type: `string`

Default: `"IKEv2"`

### <a name="input_custom_bgp_addresses"></a> [custom\_bgp\_addresses](#input\_custom\_bgp\_addresses)

Description: Custom APIPA Adresses for BGP

- `primary` - Required.
- `secondary` - (Optional) Configure in an Active/Active Gateway setting.

Type:

```hcl
object({
    primary   = string
    secondary = optional(string, null)
  })
```

Default: `null`

### <a name="input_dpd_timeout_seconds"></a> [dpd\_timeout\_seconds](#input\_dpd\_timeout\_seconds)

Description: The dead peer detection timeout of this connection in seconds. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_egress_nat_rule_ids"></a> [egress\_nat\_rule\_ids](#input\_egress\_nat\_rule\_ids)

Description: A list of the egress NAT Rule Ids.

Type: `list(string)`

Default: `null`

### <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp)

Description: If true, BGP (Border Gateway Protocol) is enabled for this connection. Defaults to false.

Type: `bool`

Default: `null`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetry.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_express_route_circuit_id"></a> [express\_route\_circuit\_id](#input\_express\_route\_circuit\_id)

Description: The ID of the Express Route Circuit when creating an ExpressRoute connection (i.e. when type is ExpressRoute). The Express Route Circuit can be in the same or in a different subscription. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_express_route_gateway_bypass"></a> [express\_route\_gateway\_bypass](#input\_express\_route\_gateway\_bypass)

Description: If true, data packets will bypass ExpressRoute Gateway for data forwarding This is only valid for ExpressRoute connections

Type: `bool`

Default: `null`

### <a name="input_ingress_nat_rule_ids"></a> [ingress\_nat\_rule\_ids](#input\_ingress\_nat\_rule\_ids)

Description: A list of the ingress NAT Rule Ids.

Type: `list(string)`

Default: `null`

### <a name="input_ipsec_policy"></a> [ipsec\_policy](#input\_ipsec\_policy)

Description: CIDR blocks for traffic selectors

-  `dh_group `             = (Required) The DH group used in IKE phase 1 for initial SA. Valid options are DHGroup1, DHGroup14, DHGroup2, DHGroup2048, DHGroup24, ECP256, ECP384, or None.
-  `ike_encryption`         = (Required) The IKE encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, or GCMAES256.
-  `ike_integrity`          = (Required) The IKE integrity algorithm. Valid options are GCMAES128, GCMAES256, MD5, SHA1, SHA256, or SHA384.
-  `ipsec_encryption`       = (Required) The IPSec encryption algorithm. Valid options are AES128, AES192, AES256, DES, DES3, GCMAES128, GCMAES192, GCMAES256, or None.
-  `ipsec_integrity`        = (Required) The IPSec integrity algorithm. Valid options are GCMAES128, GCMAES192, GCMAES256, MD5, SHA1, or SHA256.
-  `pfs_group`              = (Required) The DH group used in IKE phase 2 for new child SA. Valid options are ECP256, ECP384, PFS1, PFS14, PFS2, PFS2048, PFS24, PFSMM, or None.
-  `sa_datasize`            = (optional) The IPSec SA payload size in KB. Must be at least 1024 KB. Defaults to 102400000 KB.
-  `sa_lifetime`            = optional The IPSec SA lifetime in seconds. Must be at least 300 seconds. Defaults to 27000 seconds.

Type:

```hcl
map(object({
    dh_group         = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_datasize      = optional(string)
    sa_lifetime      = optional(string)

  }))
```

Default: `{}`

### <a name="input_local_azure_ip_address_enabled"></a> [local\_azure\_ip\_address\_enabled](#input\_local\_azure\_ip\_address\_enabled)

Description: Use private local Azure IP for the connection. Changing this forces a new resource to be created.

Type: `bool`

Default: `null`

### <a name="input_local_network_gateway_id"></a> [local\_network\_gateway\_id](#input\_local\_network\_gateway\_id)

Description: The ID of the Azure Local Network Gateway to connect to.

Type: `string`

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_private_link_fast_path_enabled"></a> [private\_link\_fast\_path\_enabled](#input\_private\_link\_fast\_path\_enabled)

Description: Bypass the Express Route gateway when accessing private-links. When enabled express\_route\_gateway\_bypass must be set to

Type: `bool`

Default: `null`

### <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight)

Description: The routing weight. Defaults to 10

Type: `number`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

### <a name="input_traffic_selector_policy"></a> [traffic\_selector\_policy](#input\_traffic\_selector\_policy)

Description: CIDR blocks for traffic selectors

- `local_address_cidrs` - Required.
- `remote_address_cidrs` - Required.

Type:

```hcl
map(object({
    local_address_cidrs  = string
    remote_address_cidrs = string
  }))
```

Default: `{}`

### <a name="input_use_policy_based_traffic_selectors"></a> [use\_policy\_based\_traffic\_selectors](#input\_use\_policy\_based\_traffic\_selectors)

Description: If true, policy-based traffic selectors are enabled for this connection. Enabling policy-based traffic selectors requires an ipsec\_policy block.

Type: `bool`

Default: `null`

## Outputs

No outputs.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->