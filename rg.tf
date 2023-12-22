resource "azurerm_resource_group" "network" {
  name     = "rg-wpp-wt-${var.opco}-${module.location-lookup.location-lookup["location_short"]}-01"
  location = var.location
}