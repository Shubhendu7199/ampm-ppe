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

variable "client_name" {
  type = string
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
      })
    )
  )
  default = null
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "storage_accounts" {
  type = map(object({
    account_tier             = optional(string)
    access_tier              = optional(string)
    nfsv3_enabled            = optional(bool)
    is_hns_enabled           = optional(bool)
    large_file_share_enabled = optional(bool)
    account_replication_type = optional(string)
    account_kind             = optional(string)
    network_rules = optional(object({
      default_action               = string
      bypass                       = optional(list(string))
      ip_rules                     = optional(list(string))
      virtual_network_subnet_names = optional(list(string))
    }))
    file_shares = optional(list(object({
      name             = string
      quota            = number
      access_tier      = optional(string)
      enabled_protocol = optional(string)
    })))
    containers = optional(list(object({
      name = string
    })))
  }))
  default = null
}

variable "eventhub_resources" {
  type = map(object({
    sku = string
    network_rulesets = object({
      default_action = string
      vnets = map(object({
        subnet_id = string
      }))
    })
    authorization_rule = object({
      name = string
    })

    eventhubs = map(object({
      partition_count   = number
      message_retention = number
      # authorization_rule = object({
      #   name   = string
      #   listen = bool
      #   send   = bool
      # })
      # consumer_groups = list(object({
      #   name = string
      # }))
    }))
  }))
}