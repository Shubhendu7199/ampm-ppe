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

variable "resource_group_name" {
  type = string
}
