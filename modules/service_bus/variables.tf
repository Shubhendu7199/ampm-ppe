variable "resource_group_name" {
  type = string
}

variable "rg_location" {
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
    tags = optional(map(string))
  }))
}