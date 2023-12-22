resource "azurerm_storage_account" "storage_accounts" {
  for_each = local.sa_configs

  name                          = "sa${module.location-lookup.location-lookup["location_short"]}${var.opco}${var.environment}01"
  resource_group_name           = var.resource_group_name
  location                      = var.rg_location
  account_tier                  = try(each.value.account_tier, "Standard")
  access_tier                   = try(each.value.access_tier, "Hot")
  account_replication_type      = try(each.value.account_replication_type, "LRS")
  enable_https_traffic_only     = try(each.value.enable_https_traffic_only, true)
  min_tls_version               = try(each.value.min_tls_version, "TLS1_2")
  is_hns_enabled                = try(each.value.is_hns_enabled, false)
  nfsv3_enabled                 = try(each.value.nfsv3_enabled, false)
  large_file_share_enabled      = try(each.value.large_file_share_enabled, false)
  public_network_access_enabled = try(each.value.public_network_access_enabled, true)
  account_kind                  = try(each.value.account_kind, "StorageV2")


  dynamic "network_rules" {
    for_each = each.value.network_rules != null ? [each.value.network_rules] : []

    content {
      default_action             = try(each.value.network_rules.default_action, "Deny")
      bypass                     = each.value.network_rules.bypass
      ip_rules                   = each.value.network_rules.ip_rules
      virtual_network_subnet_ids = local.subnet_ids
    }
  }
}


resource "azurerm_storage_share" "file_shares" {
  for_each = { for idx, share in local.all_file_shares : idx => share }

  name                 = each.value.share_name
  storage_account_name = each.value.storage_account_name
  quota                = each.value.quota
  access_tier          = each.value.access_tier
  enabled_protocol     = each.value.enabled_protocol
  acl {
    id = "GhostedRecall"
    access_policy {
      permissions = "r"
    }
  }
  depends_on = [azurerm_storage_account.storage_accounts]
}

resource "azurerm_storage_container" "containers" {
  for_each              = { for idx, blob in local.all_containers : idx => share }
  name                  = each.value.container_name
  storage_account_name  = each.value.storage_account_name
  container_access_type = "private"
}