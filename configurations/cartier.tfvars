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
          service_endpoints = ["Microsoft.Storage", "Microsoft.EventHub", "Microsoft.Web"]
          delegation        = "Microsoft.Web/serverFarms"
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

# private_endpoints = {
#   pe1 = {
#     name         = "private-endpoint-5"
#     subnet_name  = "snet-wt-ampm-cartier-ase-p-dmz-subnet-01"
#     vnet_name    = "vnet-wt-ampm-cartier-ase-p-dmz-01"
#     vnet_rg_name = "rg-wpp-wt-ampm-cartier-ase-01"

#     private_service_connection = {
#       name                    = "connection-1"
#       is_manual_connection    = false
#       subresource_names       = ["namespace"]
#       target_resource_rg_name = "rg-wpp-wt-ampm-cartier-ase-01"
#       target_resource_type    = "namespace"
#       target_resource_name    = "EvenHubsNamespacee-wpp-wt"
#     }
#     private_dns_zone_group = {
#       name                 = "sa-dns-zone"
#       private_dns_zone_ids = ["privatelink.file.core.windows.net"]
#     }
#   }
# }

# sql_server = {
#   "shubhzarakiserver1" = {
#     sku_name = "GP_Standard_D2ds_v4"
#     version  = "8.0.21"

#     sql_configurations = {
#       config01 = {
#         name  = "config_name_1"
#         value = "config_value_1"
#       }
#       config02 = {
#         name  = "config_name_2"
#         value = "config_value_2"
#       }
#     }

#     sql_firewall_rules = {
#       fwrule01 = {
#         name             = "firewall_rule_1"
#         start_ip_address = "10.0.0.1"
#         end_ip_address   = "10.0.0.10"
#       }
#       fwrule02 = {
#         name             = "firewall_rule_2"
#         start_ip_address = "10.0.0.11"
#         end_ip_address   = "10.0.0.20"
#       }
#     }
#   }
# }

app_service_plans = {
  "app-service-plan1-name" = {
    os_type  = "Windows"
    sku_name = "B1"
  }
  "app-service-plan2-name" = {
    os_type  = "Linux"
    sku_name = "P2v3"
  }
}

app_services = {
  "app-service02-name" = {
    service_plan_id = "/subscriptions/10e0ad56-8242-45e7-b95a-a64f4eb4542f/resourceGroups/rg-wpp-wt-ampm-cartier-ase-01/providers/Microsoft.Web/serverfarms/app-service-plan2-name"
    enabled         = true
    https_only      = true
    site_config = {
      always_on          = true
      websockets_enabled = false
      app_command_line   = "pm2 start /home/site/wwwroot/ecosystem.config.js --no-daemon"
      application_stack = {
        node_version = "16-lts"
      }
    }
    app_settings = {
      "WEBSITE_DNS_SERVER" = "168.63.129.16"
      "TZ"                 = "your_timezone"
    }
    vnet_connection = {
      subnet_id = "/subscriptions/10e0ad56-8242-45e7-b95a-a64f4eb4542f/resourceGroups/rg-wpp-wt-ampm-cartier-ase-01/providers/Microsoft.Network/virtualNetworks/vnet-wt-ampm-cartier-ase-p-dmz-01/subnets/snet-wt-ampm-cartier-ase-p-dmz-subnet-01"
    }
    tags = {
      "Architectural Functional Group" = "Frontend"
    }
  }
}
