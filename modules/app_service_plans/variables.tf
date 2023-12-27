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