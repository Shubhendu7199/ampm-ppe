resource "azurerm_application_insights" "webinsight1" {
  name                = "appinsight-wpp-wt-${module.location-lookup.location-lookup["location_short"]}-${var.opco}-${var.client_name}-${var.environment}-01"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  application_type    = "web"

  depends_on = [azurerm_resource_group.ampm]
}

resource "azurerm_automation_account" "example" {
  name                = "aa-wpp-wt-ase-${var.opco}-${var.client_name}-${var.environment}"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  sku_name            = "Basic"

  depends_on = [azurerm_resource_group.ampm]
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
  client_name                              = var.client_name
  providers = {
    azurerm = azurerm
  }
  depends_on = [azurerm_resource_group.ampm]
}

module "location-lookup" {
  source   = "./modules/location-lookup"
  location = var.region
}

module "storage_account" {
  source                     = "./modules/storage_account"
  storage_accounts           = var.storage_accounts
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = azurerm_resource_group.ampm.location
  opco                       = var.opco
  environment                = var.environment
  subscription_id            = var.subscription_id
  location                   = var.region
  client_name                = var.client_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  depends_on                 = [azurerm_resource_group.ampm]
}

module "eventhub_resources" {
  source                     = "./modules/eventhub_resources"
  eventhub_resources         = var.eventhub_resources
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = azurerm_resource_group.ampm.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

module "key_vault" {
  source                     = "./modules/key_vault"
  key_vaults                 = var.key_vaults
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = azurerm_resource_group.ampm.location
  random_password            = random_password.password.result
  client_name                = var.client_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

module "private_dns_zones" {
  source              = "./modules/private_dns_zones"
  private_dns_zones   = var.private_dns_zones
  resource_group_name = azurerm_resource_group.ampm.name
}

# module "private_endpoint" {
#   source              = "./modules/private_endpoints"
#   private_endpoints   = var.private_endpoints
#   resource_group_name = azurerm_resource_group.ampm.name
#   rg_location         = azurerm_resource_group.ampm.location
#   depends_on          = [module.private_dns_zones]
# }

module "flexible_sql_server" {
  source                     = "./modules/flexible_sql_server"
  sql_server                 = var.sql_server
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = "uksouth"
  random_password            = random_password.password.result
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

module "app_service_plan" {
  source              = "./modules/app_service_plans"
  resource_group_name = azurerm_resource_group.ampm.name
  rg_location         = azurerm_resource_group.ampm.location
  app_service_plans   = var.app_service_plans
}

module "app_services" {
  source                     = "./modules/app_services"
  app_services               = var.app_services
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = azurerm_resource_group.ampm.location
  instrumentation_key        = azurerm_application_insights.webinsight1.instrumentation_key
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}


module "servicebus_resources" {
  source                     = "./modules/service_bus"
  servicebus_resources       = var.servicebus_resources
  resource_group_name        = azurerm_resource_group.ampm.name
  rg_location                = azurerm_resource_group.ampm.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}