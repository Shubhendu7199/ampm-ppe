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
      { name = "shubhendu", quota = 100, access_tier = "TransactionOptimized" },
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
      }
    }

    authorization_rule = {
      name = "authorization-rule-namespace1"
    }

    eventhubs = {
      "LineEvent" = {
        partition_count   = 8
        message_retention = 7
        authorization_rule = {
          name   = "LineEventAuthorizationRule"
          listen = true
        }
        consumer_groups = [
          { name = "LineEventAutoReply" },
          { name = "LineEventTracking" },
        ]
      }

      "CampaignInbound" = {
        partition_count   = 8
        message_retention = 7
        authorization_rule = {
          name   = "CampaignInboundAuthorizationRule"
          listen = true
          send   = true
        }
        consumer_groups = [
          { name = "RichMenu" },
        ]
      }
    }
  }
}

key_vaults = {
  "zarakishubhendu" = {
    sku = "standard"
    rbac = [
      {
        object_id               = "1c04cebb-44d4-415b-8a3d-fda50ad86887"
        key_permissions         = ["Get", "List"]
        secret_permissions      = ["Get"]
        certificate_permissions = ["Get", "List"]
      }
    ]
  }
}


private_dns_zones = {
  zone1 = {
    name = "privatelink.file.core.windows.net"
    vnet_link = {
      link01 = {
        vnet_id = ["vnet-wt-ampm-cartier-ase-p-dmz-01"]
      }
    }
  }
  zone2 = {
    name = "privatelink.azurewebsites.net"
    vnet_link = {
      link01 = {
        vnet_id = ["vnet-wt-ampm-cartier-ase-p-dmz-01"]
      }
    }
  }
}