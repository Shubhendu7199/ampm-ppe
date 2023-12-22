variable "location" {
  type        = string
  description = "The Azure Region name the resource is being created."
  nullable    = true
}

variable "location_short" {
  type        = map(string)
  description = "Short location codes."
  default = {
    northeurope        = "eun"
    uksouth            = "uks"
    ukwest             = "ukw"
    eastus2            = "ue2"
    southeastasia      = "ase"
    germanywestcentral = "gwc"
    southafricanorth   = "san"
    centralindia       = "inc"
  }
}