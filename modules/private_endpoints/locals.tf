locals {
  private_endpoints_config = var.private_endpoints

  subnet_id = {
    for k, v in local.private_endpoints_config : k => format(
      "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s",
      data.azurerm_subscription.current.subscription_id,
      v.vnet_rg_name,
      v.vnet_name,
      v.subnet_name
    )
  }

  target_resource_providers = {
    storageaccount = "Microsoft.Storage/storageAccounts"
    vault          = "Microsoft.KeyVault/vaults"
    sites          = "Microsoft.Web/sites"
    mysqlServer    = "Microsoft.DBforMySQL/flexibleServers"
    namespace      = "Microsoft.EventHub/namespaces"
  }

  private_connection_resource_id = {
    for k, v in local.private_endpoints_config : k => format(
      "/subscriptions/%s/resourceGroups/%s/providers/%s/%s",
      data.azurerm_subscription.current.subscription_id,
      v.private_service_connection.target_resource_rg_name,
      local.target_resource_providers[v.private_service_connection.target_resource_type],
      v.private_service_connection.target_resource_name
    )
  }

  private_dns_zone_ids = {
    for k, v in local.private_endpoints_config : k => [
      for zone_id in v.private_dns_zone_group.private_dns_zone_ids :
      format(
        "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/privateDnsZones/%s",
        data.azurerm_subscription.current.subscription_id,
        v.private_service_connection.target_resource_rg_name,
        zone_id
      )
    ]
    if v.private_dns_zone_group != null
  }
}