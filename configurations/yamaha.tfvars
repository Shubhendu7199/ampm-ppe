subscription_id = "10e0ad56-8242-45e7-b95a-a64f4eb4542f"
environment     = "p"
region          = "southeastasia"
opgroup         = "wt"
opco            = "ampm"
client_name     = "yamaha"


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

storage_accounts = {
  sa1 = {
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind             = "FileStorage"
    file_shares = [
      { name = "shubhendu", quota = 100, access_tier = "Premium", enabled_protocol = "NFS" },
    ]
    containers = [
      { name = "adminlte" }
    ]
  }
}