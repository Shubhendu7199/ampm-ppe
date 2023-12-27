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


variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}