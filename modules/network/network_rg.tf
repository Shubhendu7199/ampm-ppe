resource "azurerm_resource_group" "network" {
  name     = local.rg_name
  location = var.location
}