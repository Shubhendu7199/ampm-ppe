locals {
  sa_configs = var.storage_accounts

  subnet_ids = [
    for subnet_name in flatten([
      for rule in values(var.storage_accounts) :
      rule.network_rules != null ? coalesce(rule.network_rules.virtual_network_subnet_names, []) : []
    ]) :
    format(
      "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s",
      length(split("/", subnet_name)) > 3 ? split("/", subnet_name)[0] : var.subscription_id,
      split("/", subnet_name)[length(split("/", subnet_name)) - 3],
      split("/", subnet_name)[length(split("/", subnet_name)) - 2],
      split("/", subnet_name)[length(split("/", subnet_name)) - 1],
    )
  ]

  all_file_shares = flatten([
    for sa_name, sa_config in var.storage_accounts : [
      for share in coalesce(sa_config.file_shares, []) : {
        share_name       = share.name
        quota            = share.quota
        access_tier      = share.access_tier
        enabled_protocol = share.enabled_protocol
      }
    ]
  ])

  all_containers = flatten([
    for sa_name, sa_config in var.storage_accounts : [
      for container in coalesce(sa_config.containers, []) : {
        container_name = container.name
      }
    ]
  ])

}