resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  for_each = var.eventhub_resources

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.rg_location
  sku                 = each.value.sku

  #   network_rulesets {
  #     default_action = each.value.network_rulesets.default_action

  #     dynamic "virtual_network_rule" {
  #       for_each = each.value.network_rulesets.vnets

  #       content {
  #         ignore_missing_virtual_network_service_endpoint = false
  #         subnet_id                                       = virtual_network_rule.value.subnet_id
  #       }
  #     }
  #   }
  # }

  dynamic "network_rules" {
    for_each = each.value.network_rulesets != null ? [each.value.network_rulesets] : []

    content {
      default_action = network_rules.value.default_action

      dynamic "virtual_network_rule" {
        for_each = lookup(network_rules.value, "vnets", {})

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
  resource_group_name = each.value.rg_name

  listen = true
  send   = true
  manage = true
}