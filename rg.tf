resource "azurerm_resource_group" "network" {
  name     = "rg-wpp-wt-${var.opco}-01"
  location = var.location
}