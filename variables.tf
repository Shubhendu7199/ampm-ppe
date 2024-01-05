variable "opgroup" {
  type        = string
  description = "Name of the Group"
  validation {
    condition     = length(var.opgroup) <= 13
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
    index_number             = number
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
      authorization_rule = object({
        name   = string
        listen = optional(bool)
        send   = optional(bool)
      })
      consumer_groups = list(object({
        name = string
      }))
    }))
  }))
}

variable "key_vaults" {
  type = map(object({
    sku = string
    rbac = list(object({
      object_id               = string
      key_permissions         = list(string)
      secret_permissions      = list(string)
      certificate_permissions = list(string)
    }))
  }))
}

variable "private_dns_zones" {
  type = map(object({
    name = string
    vnet_link = map(object({
      vnet_id              = list(string)
      vnet_subscription_id = optional(string)
      vnet_rg_name         = optional(string)
    }))
  }))
}

# variable "private_endpoints" {
#   description = "Map of private endpoint configurations"
#   type = map(object({
#     name         = string
#     subnet_name  = string
#     vnet_name    = string
#     vnet_rg_name = string
#     private_service_connection = object({
#       name                    = string
#       is_manual_connection    = bool
#       target_resource_rg_name = string
#       target_resource_type    = string
#       target_resource_name    = string
#       subresource_names       = list(string)
#     })
#     private_dns_zone_group = optional(object({
#       name                 = optional(string)
#       private_dns_zone_ids = optional(list(string))
#     }))
#   }))

#   default = null
# }


variable "sql_server" {
  type = map(object({
    sku_name = string
    version  = string
    sql_configurations = map(object({
      name  = string
      value = string
    }))
    sql_firewall_rules = map(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
    }))
  }))
}

variable "app_service_plans" {
  type = map(object({
    os_type  = string
    sku_name = string
  }))
}

variable "app_services" {
  description = "Map of app services configuration."
  type = map(object({
    service_plan_id = string
    enabled         = bool
    https_only      = bool

    site_config = object({
      always_on          = bool
      websockets_enabled = bool
      app_command_line   = string

      ip_restriction = optional(object({
        action                    = string
        headers                   = map(list(string))
        ip_address                = optional(string)
        name                      = string
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
      }))

      application_stack = object({
        php_version  = optional(string)
        node_version = optional(string)
      })
    })

    app_settings = map(string)

    vnet_connection = object({
      subnet_id = string
    })

    tags = map(string)
  }))
}

variable "servicebus_resources" {
  type = map(object({
    sku = string
    namespace_auth_rules = map(object({
      listen = bool
      send   = bool
      manage = bool
    }))
    topics = map(object({
      topic_auth_rules = map(object({
        listen = bool
        send   = bool
        manage = bool
      }))
    }))
    tags = optional(map(string))
  }))
}