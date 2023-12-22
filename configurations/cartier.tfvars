subscription_id = "10e0ad56-8242-45e7-b95a-a64f4eb4542f"
environment     = "p"
region          = "southeastasia"
opgroup         = "wt"
opco            = "ampm"
client_name     = "cartier"


networks = {
  "southeastasia" = {
    "dmz-01" = {
      address_space = ["10.0.0.0/24"]
      subnets = {
        "dmz-subnet-01" = {
          address_prefix    = "10.0.0.0/24"
          service_endpoints = ["Microsoft.Storage", "Microsoft.EventHub"]
        }
      }
    }
  }
}

storage_accounts = {
  sa1 = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    file_shares = [
      { name = "shubhendu", quota = 100, access_tier = "Premium", enabled_protocol = "NFS" },
    ]
    containers = [
      { name = "adminlte" }
    ]
  }
}

eventhub_resources = {
  "EvenHubsNamespacee-wpp-wt" = {
    sku = "Standard"
    network_rulesets = {
      default_action = "Deny"
      vnets = {
        vnet_rule01 = {
          subnet_id = "/subscriptions/10e0ad56-8242-45e7-b95a-a64f4eb4542f/resourceGroups/rg-wpp-wt-ampm-cartier-ase-01/providers/Microsoft.Network/virtualNetworks/vnet-wt-ampm-cartier-ase-p-dmz-01/subnets/snet-wt-ampm-cartier-ase-p-dmz-subnet-01"
        }
        # vnet_rule02 = {
        #   subnet_id = "/subscriptions/10e0ad56-8242-45e7-b95a-a64f4eb4542f/resourceGroups/rg-wpp-wt-ampm-cartier-ase-01/providers/Microsoft.Network/virtualNetworks/vnet-wt-ampm-cartier-ase-p-dmz-01/subnets/snet-wt-ampm-cartier-ase-p-dmz-subnet-02"
        # }
      }
    }

    authorization_rule = {
      name = "authorization-rule-namespace1"
    }
  }
}

# eventhub_resources = {
#   EvenHubsNamespacee-wpp-wt = {
#     sku = "Standard"
#     network_rulesets = {
#       default_action = "deny"
#       vnets = {
#         vnet_rule01 = {
#           subnet_id = "/subscriptions/10e0ad56-8242-45e7-b95a-a64f4eb4542f/resourceGroups/rg-wpp-wt-ampm-cartier-ase-01/providers/Microsoft.Network/virtualNetworks/vnet-wt-ampm-cartier-ase-p-dmz-01/subnets/snet-wt-ampm-cartier-ase-p-dmz-subnet-01"
#         }
#       }
#     }
#     authorization_rule = {
#       name = "authorization-rule-namespace1"
#     }
#   }
# }
