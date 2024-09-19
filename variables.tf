variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."

  validation {
    condition     = can(regex("TODO", var.name))
    error_message = "The name must be TODO." # TODO remove the example below once complete:
    #condition     = can(regex("^[a-z0-9]{5,50}$", var.name))
    #error_message = "The name must be between 5 and 50 characters long and can only contain lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}
variable "azvirtual_network_gateway_id" {
  type = string
  description = "The ID of the Azure Virtual Network Gateway to connect to."
}

variable "type" {
  description = "The type of connection. Must be one of 'Vnet2Vnet', 'ExpressRoute', or 'IPsec'."
  type        = string

  validation {
    condition     = contains(["Vnet2Vnet", "ExpressRoute", "IPsec"], var.type)
    error_message = "The type must be one of 'Vnet2Vnet', 'ExpressRoute', or 'IPsec'."
  }
}

variable "shared_key " {
  type = string
  description = "value of the shared key for both ends of the connection."
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

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
