locals {
  wpp_prefix          = "wpp-${var.opgroup}-${module.location-lookup.location-lookup["location_short"]}-${var.environment_short[var.environment]}"
  prefix              = "${var.opgroup}-${var.opco}-${module.location-lookup.location-lookup["location_short"]}-${var.environment_short[var.environment]}"
  rg_name             = "rg-${local.prefix}-network-01"
  route_table_name    = "rt-${local.prefix}-firewall-01"
  ipaddresses_RFC1918 = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

  subnet_list = flatten([
    for network_name, network in var.networks : [
      for subnet_name, subnet in network.subnets : merge(subnet, {
        subnet_name = subnet_name
        vnet_name   = network_name
        subnet_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s",
          var.subscription_id,
          local.rg_name,
          "vnet-${local.prefix}-${network_name}",
          "snet-${local.prefix}-${subnet_name}"
        )
        service_endpoints = subnet.service_endpoints
        delegation = subnet.delegation != null ? [{
          name = subnet.delegation
          properties = {
            serviceName = subnet.delegation
          }
        }] : []
        privateEndpointNetworkPolicies    = subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies = subnet.privateLinkServiceNetworkPolicies
      })
    ]
  ])

  subnets_by_vnet = {
    for subnet in local.subnet_list : "${subnet.vnet_name}-${subnet.subnet_name}" => subnet
  }

  subnet_ids = [
    for val in local.subnet_list : val.subnet_id
  ]
}

