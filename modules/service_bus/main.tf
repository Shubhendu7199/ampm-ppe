resource "azurerm_servicebus_namespace" "example" {
  for_each            = var.servicebus_resources
  name                = each.key
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku

  tags = each.value.tags
}