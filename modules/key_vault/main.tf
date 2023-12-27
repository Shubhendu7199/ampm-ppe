resource "azurerm_key_vault" "keyvault" {
   for_each = { for kv in local.keyvault : kv.keyvault_name => kv }

  name                        = each.key
  resource_group_name         = var.resource_group_name
  location                    = var.rg_location
  sku_name                    = each.value.sku
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = false
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
}

resource "azurerm_key_vault_access_policy" "default_keyvault_rbac" {
  for_each = { for kv in local.keyvault : kv.keyvault_name => kv }

  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
}

resource "azurerm_key_vault_access_policy" "keyvault_rbac" {
  for_each = { for kv in local.keyvault : kv.keyvault_name => kv }

  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id

  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}


