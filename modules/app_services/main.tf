resource "azurerm_linux_web_app" "app_services" {
  for_each = var.app_services

  name                = each.key
  location            = var.rg_location
  resource_group_name = var.resource_group_name

  service_plan_id = each.value.service_plan_id
  enabled         = each.value.enabled
  https_only      = each.value.https_only

  site_config {
    always_on          = each.value.site_config.always_on
    websockets_enabled = each.value.site_config.websockets_enabled
    app_command_line   = each.value.site_config.app_command_line

    dynamic "ip_restriction" {
      for_each = each.value.site_config.ip_restriction == null ? [] : [1]
      content {
        action = each.value.site_config.ip_restriction.action
        headers {
          x_azure_fdid = ["${each.value.site_config.ip_restriction.headers}"]
        }
        ip_address                = each.value.site_config.ip_restriction.ip_address
        name                      = each.value.site_config.ip_restriction.name
        service_tag               = each.value.site_config.ip_restriction.service_tag
        virtual_network_subnet_id = each.value.site_config.ip_restriction.virtual_network_subnet_id
      }
    }

    application_stack {
      php_version  = each.value.site_config.application_stack.php_version
      node_version = each.value.site_config.application_stack.node_version
    }
  }

  app_settings = merge(
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY" = "${var.instrumentation_key}"
    },
    each.value.app_settings
  )

  virtual_network_subnet_id = each.value.vnet_connection.subnet_id

  tags = each.value.tags
}


resource "azurerm_monitor_diagnostic_setting" "appservicelog" {

  for_each                   = var.app_services
  name                       = "${each.key}-log"
  target_resource_id         = azurerm_linux_web_app.app_services[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceAntivirusScanAuditLogs"
  }
  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_log {
    category = "AppServiceFileAuditLogs"
  }
  enabled_log {
    category = "AppServiceAuditLogs"
  }
  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }
  enabled_log {
    category = "AppServicePlatformLogs"
  }
  metric {
    category = "AllMetrics"
  }

  depends_on = [azurerm_linux_web_app.app_services]
}