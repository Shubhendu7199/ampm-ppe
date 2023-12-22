variable "storage_accounts" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
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
}

variable "opco" {
  type = string
}

variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subscription_id" {
  type = string
}