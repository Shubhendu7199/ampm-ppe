variable "private_endpoints" {
  description = "Map of private endpoint configurations"
  type = map(object({
    name         = string
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
    private_service_connection = object({
      name                    = string
      is_manual_connection    = bool
      target_resource_rg_name = string
      target_resource_type    = string
      target_resource_name    = string
      subresource_names       = list(string)
    })
    private_dns_zone_group = optional(object({
      name                 = optional(string)
      private_dns_zone_ids = optional(list(string))
    }))
  }))

  default = null
}

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "region" {
  type        = string
  description = "The Azure region where this component is to be deployed"
}

variable "environment" {
  type = string
}

variable "client_name" {
  type = string
}