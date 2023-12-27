locals {
  app_service_plan = [for rootitem_key, rootitem in var.app_service_plans : {
    skuname                  = rootitem.skuname
    ostype                   = rootitem.ostype
    worker_count             = rootitem.worker_count
    per_site_scaling_enabled = rootitem.per_site_scaling_enabled
    zone_balancing_enabled   = rootitem.zone_balancing_enabled
  }]
}