variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "servicebus_resources" {
  type = map(object({
    sku  = string
    tags = optional(map(string))
  }))
}