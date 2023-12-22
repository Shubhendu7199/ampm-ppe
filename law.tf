resource "azurerm_resource_group" "example" {
  name     = "rg-law-${var.opco}-01"
  location = "southeastasia"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.opco}-01"
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}