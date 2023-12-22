variable "opgroup" {
  type        = string
  description = "Name of the Group"
  validation {
    condition     = length(var.opgroup) <= 13
    error_message = "Opgroup should be less than or equal to 13 characters."
  }
}

variable "opco" {
  type = string
  validation {
    condition     = length(var.opco) <= 13
    error_message = "Opgroup should be less than or equal to 13 characters."
  }
}

variable "region" {
  type = string
}

variable "environment" {
  description = "Environment used for naming purposes and tags"
  type        = string
  validation {
    condition     = contains(["p", "x", "d", "s"], var.environment)
    error_message = "Environment not found."
  }
}

variable "region_shortcut" {
  type        = map(string)
  description = "Updates region to alias"
  default = {
    northeurope        = "eun"
    uksouth            = "uks"
    ukwest             = "ukw"
    eastus             = "ue"
    eastus2            = "ue2"
    southeastasia      = "ase"
    germanywestcentral = "gwc"
    southafricanorth   = "san"
    centralindia       = "inc"
  }
}

variable "la_name" {
  description = "The name of the Log Analytics workspace instance"
  type        = string
}

variable "la_rg" {
  description = "The resource group where the Log Analytics instance resides"
  type        = string
}

variable "subscription_id" {
  type = string
}

variable "nsg_flow_logs_retention_period" {
  description = "Number of days to store NSG flow logs"
  type        = number
}

variable "nsg_flow_logs_traffic_analytics_interval" {
  description = "Interval in minutes at which to send traffic metrics to the Log Analytics instance"
  type        = number
}

variable "networks" {
  description = "Definition for each virtual network we want to create"
  type = map( # In the outer map we expect the location, for example uksouth)
    map(      # In the inner map we expect the network name (i.e, my-application)
      object({
        address_space = list(string)
        dns_servers   = optional(list(string), [])
        subnets = map(
          object({
            address_prefix                    = string
            service_endpoints                 = optional(list(string), [])
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
  )
  default = null
}