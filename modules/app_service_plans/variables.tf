variable "app_service_plans" {
  type = map(object({
    os_type  = string
    sku_name = string
  }))
}

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
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