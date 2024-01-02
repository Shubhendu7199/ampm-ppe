resource "azurerm_mysql_flexible_server" "flexsqlserver" {
  for_each = var.sql_server

  name                   = each.key
  location               = var.rg_location
  resource_group_name    = var.resource_group_name
  administrator_login    = "ampmdbadmin"
  administrator_password = var.random_password
  sku_name               = each.value.sku_name
  version                = each.value.version
  storage {
    auto_grow_enabled = true
  }
  backup_retention_days = 35

  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_mysql_flexible_server_configuration" "mysql_flexserver__configurations" {
  for_each = { for k, v in local.config : k => v }

  name                = each.value.name
  value               = each.value.value
  resource_group_name = each.value.resource_group_name
  server_name         = each.value.server_name
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysql__flexserver_firewall_rules" {
  for_each = { for k, v in local.fw_rules : k => v }

  name                = each.value.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  resource_group_name = each.value.resource_group_name
  server_name         = each.value.server_name
}

resource "azurerm_monitor_diagnostic_setting" "mysqlserverdiag" {
  for_each                   = var.sql_server
  name                       = "${each.key}-log"
  target_resource_id         = azurerm_mysql_flexible_server.flexsqlserver[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id


  enabled_log {
    category = "MySqlAuditLogs"
  }
  enabled_log {
    category = "MySqlSlowLogs"
  }
  metric {
    category = "AllMetrics"
  }
}