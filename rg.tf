resource "azurerm_resource_group" "ampm" {
  name     = "rg-wpp-wt-${var.opco}-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-01"
  location = var.region
}