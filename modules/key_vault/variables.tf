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

variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "client_name" {
  type = string
}

variable "random_password" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type        = string
  description = "The Azure region where this component is to be deployed"
}