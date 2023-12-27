locals {
  vnet_links = flatten([
    for zone_key, zone_value in var.private_dns_zones : [
      for link_key, link_value in zone_value.vnet_link : [
        for u in link_value.vnet_id : {
          name                  = u
          private_dns_zone_name = zone_value.name
          virtual_network_id    = u
          vnet_subscription_id  = link_value.vnet_subscription_id
          vnet_rg_name          = link_value.vnet_rg_name
        }
      ]
    ]
  ])
}
