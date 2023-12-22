resource "azapi_update_resource" "subnet_properties" {
  for_each = {
    for idx, subnet in local.subnet_list : idx => subnet
  }
  type        = "Microsoft.Network/virtualNetworks/subnets@2023-04-01"
  resource_id = each.value.subnet_id
  locks       = local.subnet_ids
  body = jsonencode({
    properties = {
      serviceEndpoints = [
        for service in each.value.service_endpoints : {
          service = service
        }
      ],
      delegations                       = each.value.delegation
      privateEndpointNetworkPolicies    = each.value.privateEndpointNetworkPolicies != null ? each.value.privateEndpointNetworkPolicies : "Disabled"
      privateLinkServiceNetworkPolicies = each.value.privateLinkServiceNetworkPolicies != null ? each.value.privateLinkServiceNetworkPolicies : "Enabled"
    }
  })
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.nsg,
    azurerm_subnet_route_table_association.subnet,
    azurerm_resource_group.network
  ]
}