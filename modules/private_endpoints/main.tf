module "location-lookup" {
  source   = "../location-lookup"
  location = var.region
}

resource "azurerm_private_endpoint" "private_endpoints" {
  for_each = local.private_endpoints_config

  name                = "pep-wpp-wt-ampm-${var.client_name}-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${each.value.name}"
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  subnet_id           = local.subnet_id[each.key]

  private_service_connection {
    name                           = each.value.private_service_connection.name
    is_manual_connection           = each.value.private_service_connection.is_manual_connection
    private_connection_resource_id = local.private_connection_resource_id[each.key]
    subresource_names              = each.value.private_service_connection.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = try(each.value.private_dns_zone_group.private_dns_zone_ids, [])
    content {
      name                 = each.value.private_dns_zone_group.name
      private_dns_zone_ids = local.private_dns_zone_ids[each.key]
    }
  }
}

