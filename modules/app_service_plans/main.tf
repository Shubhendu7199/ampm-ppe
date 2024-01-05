module "location-lookup" {
  source   = "../location-lookup"
  location = var.region
}

resource "azurerm_service_plan" "app_service_plans" {
  for_each = var.app_service_plans

  name                = "asp-wpp-wt-ampm-${module.location-lookup.location-lookup["location_short"]}-${var.environment}-${var.client_name}-${each.key}"
  location            = var.rg_location
  resource_group_name = var.resource_group_name
  sku_name            = each.value.sku_name
  os_type             = each.value.os_type
}