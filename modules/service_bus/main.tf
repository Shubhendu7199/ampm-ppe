resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  for_each            = var.servicebus_resources
  name                = each.key
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku

  tags = each.value.tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "example" {

  for_each     = { for k, v in local.namespace_auth_rules : k => v }
  name         = each.value.auth_rule_name
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace[each.value.namespace_name].id

  listen = each.value.config.listen
  send   = each.value.config.send
  manage = each.value.config.manage
}