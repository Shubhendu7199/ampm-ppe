resource "azurerm_virtual_network" "vnet" {
  for_each            = var.networks
  name                = "vnet-${local.prefix}-${each.key}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.rg_location
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  tags                = var.tags

  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name           = subnet.key != "AzureBastionSubnet" && subnet.key != "GatewaySubnet" ? "snet-${local.prefix}-${subnet.key}" : subnet.key
      address_prefix = subnet.value.address_prefix
      security_group = subnet.key != "GatewaySubnet" ? azurerm_network_security_group.nsg["${each.key}-${subnet.key}"].id : null
    }
  }
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}