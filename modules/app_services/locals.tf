locals {
  app_services_flat = flatten([
    for name, app_service in var.app_services : [
      for key, value in app_service : {
        app_service_name = name
        key              = key
        value            = value
      }
    ]
  ])
}