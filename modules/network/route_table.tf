# resource "azurerm_route_table" "northbound" {
#   name                = local.route_table_name
#   location            = azurerm_resource_group.network.location
#   resource_group_name = azurerm_resource_group.network.name

#   route {
#     name                   = "DefaultRoute"
#     address_prefix         = "0.0.0.0/0"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
#   }
# }

# resource "azurerm_subnet_route_table_association" "subnet" {
#   for_each       = { for k, v in local.subnets_by_vnet : k => v if length(regexall(".*AzureBastionSubnet*", k)) == 0 && length(regexall(".*GatewaySubnet*", k)) == 0 && length(regexall(".*sql-mi-subnet-01*", k)) == 0 }
#   route_table_id = azurerm_route_table.northbound.id
#   subnet_id      = "${azurerm_virtual_network.vnet[each.value.vnet_name].id}/subnets/snet-${local.prefix}-${each.value.subnet_name}" # We have to hardcode the subnet ID here because the subnet properties from azurerm_virtual_network are only known after apply and create a circular dependency
# }