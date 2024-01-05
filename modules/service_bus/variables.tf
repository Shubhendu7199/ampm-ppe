variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "log_analytics_workspace_id" {
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