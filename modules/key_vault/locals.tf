locals {
  keyvault = flatten([
    for kv_name, kv_config in var.key_vaults : [
      {
        name = kv_name
        sku  = kv_config.sku
      }
    ]
  ])

  keyvault_rbac = flatten([
    for kv_name, kv_config in var.key_vaults : [
      for rbac_config in kv_config.rbac : {
        keyvault_name           = kv_name
        object_id               = rbac_config.object_id
        key_permissions         = rbac_config.key_permissions
        secret_permissions      = rbac_config.secret_permissions
        certificate_permissions = rbac_config.certificate_permissions
      }
    ]
  ])
}
