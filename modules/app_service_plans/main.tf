module "location-lookup" {
  source   = "../location-lookup"
  location = var.location
}

resource "azurerm_service_plan" "asplan" {
  for_each               = { for a in local.app_service_plan : a.fullname => a }
  name                   = "appservplan-${each.value.name}-wpp-wt-${var.environment.shortlocation}-${var.client_name}-${var.environment}"
  resource_group_name    = var.resource_group_name
  location               = var.rg_location
  sku_name               = each.value.skuname
  os_type                = each.value.ostype
  zone_balancing_enabled = each.value.zone_balancing_enabled
  worker_count           = each.value.worker_count
}