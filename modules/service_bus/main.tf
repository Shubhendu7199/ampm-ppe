module "location-lookup" {
  source   = "../location-lookup"
  location = var.region
}

resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  for_each            = var.servicebus_resources
  name                = "sbns-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-${each.key}"
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku

  tags = each.value.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "namespace_authorization_rule" {
  for_each     = { for k, v in local.namespace_auth_rules : k => v }
  name         = "sbns-authrule-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-${each.value.auth_rule_name}"
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace[each.value.namespace_name].id

  listen = each.value.config.listen
  send   = each.value.config.send
  manage = each.value.config.manage

  depends_on = [azurerm_servicebus_namespace.servicebus_namespace]
}

resource "azurerm_servicebus_topic" "servicebus_topic" {
  for_each     = { for k, v in local.topic : k => v }
  name         = "sbt-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-${each.value.topic_name}"
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace[each.value.namespace_name].id

  depends_on = [azurerm_servicebus_namespace.servicebus_namespace]
}

resource "azurerm_servicebus_topic_authorization_rule" "servicebus_topic_authorization_rule" {
  for_each = { for k, v in local.topic : k => v }
  name     = "sbt-authrule-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-${each.value.auth_rule_name}"
  topic_id = azurerm_servicebus_topic.servicebus_topic[each.key].id
  listen   = each.value.auth_config.listen
  send     = each.value.auth_config.send
  manage   = each.value.auth_config.manage

  depends_on = [azurerm_servicebus_topic.servicebus_topic]
}

resource "azurerm_servicebus_subscription" "servicebus_subscription" {
  for_each           = { for k, v in local.topic : k => v }
  name               = "sbts-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-chat-logger"
  topic_id           = azurerm_servicebus_topic.servicebus_topic[each.key].id
  max_delivery_count = 2000

  depends_on = [azurerm_servicebus_topic.servicebus_topic]
}

resource "azurerm_monitor_diagnostic_setting" "servicebuslog" {
  for_each                   = var.servicebus_resources
  name                       = "sbns-wpp-wt-ampm-${var.client_name}-${var.environment}-${each.key}-log"
  target_resource_id         = azurerm_servicebus_namespace.servicebus_namespace[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "OperationalLogs"
  }
  enabled_log {
    category = "VNetAndIPFilteringLogs"
  }
  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_servicebus_namespace.servicebus_namespace]
}