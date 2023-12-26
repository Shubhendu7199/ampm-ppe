resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  for_each = var.eventhub_resources

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.rg_location
  sku                 = each.value.sku

  dynamic "network_rulesets" {
    for_each = each.value.network_rulesets != null ? [each.value.network_rulesets] : []

    content {
      default_action = network_rulesets.value.default_action

      dynamic "virtual_network_rule" {
        for_each = lookup(network_rulesets.value, "vnets", {})

        content {
          ignore_missing_virtual_network_service_endpoint = false
          subnet_id                                       = virtual_network_rule.value.subnet_id
        }
      }
    }
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_namespace_authorization_rule" {
  for_each = var.eventhub_resources

  name                = each.value.authorization_rule.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace[each.key].name
  resource_group_name = var.resource_group_name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub" "eventhubs" {
  for_each = flatten([
    for ns_name, ns_config in var.eventhub_resources : [
      for eh_name, eh_config in ns_config.eventhubs : {
        namespace_name    = ns_name
        name              = eh_name
        partition_count   = eh_config.partition_count
        message_retention = eh_config.message_retention
      }
    ]
  ])

  name                = each.value.name
  namespace_name      = each.value.namespace_name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention

}

resource "azurerm_eventhub_authorization_rule" "eventhub_authorization_rules" {
  for_each = flatten([
    for ns_name, ns_config in var.eventhub_resources : [
      for eh_name, eh_config in ns_config.eventhubs : {
        namespace_name = ns_name
        eventhub_name  = eh_name
        config         = eh_config
      }
    ]
  ])

  name                = each.value.config.authorization_rule.name
  namespace_name      = each.value.namespace_name
  eventhub_name       = each.value.name
  resource_group_name = var.resource_group_name

  listen = each.value.config.authorization_rule.listen
}

resource "azurerm_eventhub_consumer_group" "eventhub_consumer_groups" {
  for_each = local.test

  name                = each.value.config.name
  namespace_name      = each.value.namespace_name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = var.resource_group_name
}