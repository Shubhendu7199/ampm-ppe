resource "azurerm_application_insights" "webinsight1" {
  name                = "appinsight-wpp-wt-${module.location-lookup.location-lookup["location_short"]}-${var.opco}-${var.environment}-01"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  application_type    = "web"
}

resource "azurerm_automation_account" "example" {
  name                = "aa-wpp-wt-${module.location-lookup.location-lookup["location_short"]}}-${var.opco}-${var.environment}-01"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  sku_name            = "Basic"
}


module "network" {
  source                                   = "./modules/network"
  for_each                                 = var.networks
  opgroup                                  = var.opgroup
  opco                                     = var.opco
  location                                 = each.key
  environment                              = var.environment
  environment_short                        = local.environment_short
  tags                                     = local.tags
  resource_group_name                      = azurerm_resource_group.ampm.name
  rg_location                              = azurerm_resource_group.ampm.location
  log_analytics_workspace                  = azurerm_log_analytics_workspace.law
  nsg_flow_logs_retention_period           = var.nsg_flow_logs_retention_period
  nsg_flow_logs_traffic_analytics_interval = var.nsg_flow_logs_traffic_analytics_interval
  networks                                 = each.value
  subscription_id                          = var.subscription_id
  providers = {
    azurerm = azurerm
  }
}

module "location-lookup" {
  source   = "./modules/location-lookup"
  location = var.region
}