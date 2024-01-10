data "azurerm_network_security_group" "example" {
  for_each            = var.nsg_rules
  name                = each.key
  resource_group_name = var.resource_group_name
}