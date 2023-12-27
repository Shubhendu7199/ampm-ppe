variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "random_password" {
  type = string
}

variable "sql_server" {
  type = map(object({
    sku_name = string
    version  = string
    sql_configurations = map(object({
      name  = string
      value = string
    }))
    sql_firewall_rules = map(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
    }))
  }))
}