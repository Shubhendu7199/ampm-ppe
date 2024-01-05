resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}