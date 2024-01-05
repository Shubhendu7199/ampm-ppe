module "location-lookup" {
  source   = "../location-lookup"
  location = var.region
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = var.private_dns_zones
  name                = each.value.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  for_each              = { for k, item in local.vnet_links : k => item }
  name                  = each.value.name //TO BE REVISITED
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = each.value.private_dns_zone_name
  virtual_network_id    = "/subscriptions/${coalesce(each.value.vnet_subscription_id, data.azurerm_subscription.current.subscription_id)}/resourceGroups/${coalesce(each.value.vnet_rg_name, var.resource_group_name)}/providers/Microsoft.Network/virtualNetworks/${each.value.virtual_network_id}"
  depends_on            = [azurerm_private_dns_zone.private_dns_zone]
}