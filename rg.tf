resource "azurerm_resource_group" "ampm" {
  name     = "rg-wpp-wt-ampm-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-01"
  location = var.region
}