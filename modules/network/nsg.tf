resource "azurerm_network_security_group" "nsg" {
  for_each            = { for k, v in local.subnets_by_vnet : k => v if length(regexall(".*GatewaySubnet*", k)) == 0 }
  name                = "nsg-${local.prefix}-${each.value.subnet_name}"
  resource_group_name = var.resource_group_name
  location            = var.rg_location
  tags                = var.tags
}