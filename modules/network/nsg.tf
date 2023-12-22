resource "azurerm_network_security_group" "nsg" {
  # for_each            = local.subnets_by_vnet
  for_each            = { for k, v in local.subnets_by_vnet : k => v if length(regexall(".*GatewaySubnet*", k)) == 0 }
  name                = "nsg-${local.prefix}-${each.value.subnet_name}"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  tags                = var.tags
}

resource "azurerm_resource_group" "net_watcher" {
  name     = "network_watcher"
  location = "southeastasia"
}

resource "azurerm_network_watcher" "ampm" {
  name                = "wpp-wt-ampm-ppe-01"
  location            = azurerm_resource_group.net_watcher.location
  resource_group_name = azurerm_resource_group.net_watcher.name
}

resource "azurerm_storage_account" "test" {
  name                = "sanetworklogswtampm01"
  resource_group_name = azurerm_resource_group.net_watcher.name
  location            = azurerm_resource_group.net_watcher.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_network_watcher_flow_log" "nsg" {
  for_each                  = { for k, v in local.subnets_by_vnet : k => v if length(regexall(".*GatewaySubnet*", k)) == 0 }
  name                      = "nsg-${local.prefix}-${each.value.subnet_name}-logs"
  network_watcher_name      = azurerm_network_watcher.ampm.name
  resource_group_name       = azurerm_resource_group.net_watcher.name
  location                  = var.location
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = azurerm_storage_account.test.id 
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.nsg_flow_logs_retention_period
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace.workspace_id
    workspace_region      = var.log_analytics_workspace.location
    workspace_resource_id = var.log_analytics_workspace.id
    interval_in_minutes   = var.nsg_flow_logs_traffic_analytics_interval
  }
}