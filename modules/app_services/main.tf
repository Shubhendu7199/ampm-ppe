resource "azurerm_linux_web_app" "app_services" {
  for_each = { for i in local.app_services_flat : i.app_service_name => i }

  name                = each.key
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  service_plan_id     = each.value.service_plan_id
  enabled             = each.value.enabled
  https_only          = each.value.https_only
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on          = each.value.site_config.always_on
    websockets_enabled = each.value.site_config.websockets_enabled
    app_command_line   = each.value.site_config.app_command_line

    dynamic "application_stack" {
      for_each = each.value.application_stack

      content {
        php_version  = application_stack.value.php_version
        node_version = application_stack.value.node_version
      }
    }
    ip_restriction {
      action                    = each.value.site_config.ip_restriction.action
      headers                   = each.value.site_config.ip_restriction.headers
      ip_address                = each.value.site_config.ip_restriction.ip_address
      name                      = each.value.site_config.ip_restriction.name
      service_tag               = each.value.site_config.ip_restriction.service_tag
      virtual_network_subnet_id = each.value.site_config.ip_restriction.virtual_network_subnet_id
    }


  }



  app_settings = merge(
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = "${var.instrumentation_key}"
    },
    each.value.app_settings
  )

  tags = each.value.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_swift_connections" {
  for_each = { for i in local.app_services_flat : i.app_service_name => i }

  app_service_id = azurerm_app_service.app_services[each.key].id
  subnet_id      = each.value.vnet_connection.subnet_id
}