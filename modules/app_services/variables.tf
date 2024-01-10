variable "app_services" {
  description = "Map of app services configuration."
  type = map(object({
    service_plan_name = string
    enabled           = bool
    https_only        = bool

    site_config = object({
      always_on          = bool
      websockets_enabled = bool
      app_command_line   = string

      ip_restriction = optional(object({
        action                    = string
        headers                   = optional(map(list(string)))
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
      vnet_name   = string
      subnet_name = string
    })

    tags = map(string)
  }))
}
variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}
variable "instrumentation_key" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "client_name" {
  type = string
}

variable "region" {
  type        = string
  description = "The Azure region where this component is to be deployed"
}

variable "subscription_id" {
  type = string
}