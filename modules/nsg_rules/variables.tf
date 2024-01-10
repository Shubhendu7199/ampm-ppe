variable "nsg_rules" {
  type = map(
    map(
      object({
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      })
    )
  )
  default = {}
}


variable "resource_group_name" {
  type = string
}

variable "rg_location" {
  type = string
}