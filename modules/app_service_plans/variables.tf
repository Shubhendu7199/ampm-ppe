variable "location" {
  type        = string
  description = "The Azure region where this component is to be deployed, i.e. uksouth"
}

variable "app_service_plans" {
  description = "A map of resources to be deployed into the subscription"
  type = map(object({
    basename                 = string
    skuname                  = string
    ostype                   = string
    worker_count             = optional(number)
    per_site_scaling_enabled = optional(string)
    zone_balancing_enabled   = optional(bool)
  }))
}

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "client_name" {
  type = string
}

variable "environment" {
  description = "Environment used for naming purposes and tags"
  type        = string
}