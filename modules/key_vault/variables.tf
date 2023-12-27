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