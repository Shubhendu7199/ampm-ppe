resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.opco}-${var.client_name}-01"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}