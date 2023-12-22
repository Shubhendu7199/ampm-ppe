subscription_id = "10e0ad56-8242-45e7-b95a-a64f4eb4542f"
environment     = "p"
region          = "uksouth"


networks = {
  "southeastasia" = {
    "dmz-01" = {
      address_space = ["10.0.0.0/24"]
      subnets = {
        "dmz-subnet-01" = {
          address_prefix    = "10.0.0.0/24"
          service_endpoints = ["Microsoft.Storage"]
        }
      }
    }
  }
}