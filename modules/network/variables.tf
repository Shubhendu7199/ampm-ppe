variable "opgroup" {
  description = "Name of the Group"
  type        = string
}

variable "opco" {
  description = "Name of the company in the group"
  type        = string
}

variable "location" {
  type        = string
  description = "The Azure region where this component is to be deployed, i.e. uksouth"
}

variable "environment" {
  description = "Environment used for naming purposes and tags"
  type        = string
}

variable "environment_short" {
  description = "short-hand Environment used for naming purposes and tags"
  type        = map(string)
}

variable "tags" {
  description = "Tags which get added to the resources"
  type        = map(string)
}

variable "is_pam_enabled" {
  type    = bool
  default = false
}

variable "log_analytics_workspace" {
  description = "Map of data returned from a Terraform azurerm_log_analytics_workspace resource"
}

variable "nsg_flow_logs_retention_period" {
  description = "Number of days to store NSG flow logs"
  type        = number
}

variable "nsg_flow_logs_traffic_analytics_interval" {
  description = "Interval in minutes at which to send traffic metrics to the Log Analytics instance"
  type        = number
}

variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "networks" {
  description = "Definition for each virtual network we want to create"
  type = map(
    object({
      address_space = list(string)
      dns_servers   = optional(list(string), [])
      subnets = map(
        object({
          address_prefix                    = string
          service_endpoints                 = optional(list(string))
          delegation                        = optional(string)
          privateEndpointNetworkPolicies    = optional(string)
          privateLinkServiceNetworkPolicies = optional(string)
        })
      )
      vpn_config = optional(object({
        type          = string
        vpn_type      = string
        sku           = string
        active_active = optional(bool)
        enable_bgp    = optional(bool)
        local_networks = optional(list(object({
          remote_name            = string,
          connection_type        = optional(string, "IPsec")
          connection_protocol    = optional(string, "IKEv1")
          remote_gateway_address = string,
          remote_address_space   = list(string)
        })))
      }))
    })
  )
}