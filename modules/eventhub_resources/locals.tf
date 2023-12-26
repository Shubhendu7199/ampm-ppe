locals {
  test = flatten([
    for ns_name, ns_config in var.eventhub_resources : [
      for eh_name, eh_config in ns_config.eventhubs : [
        for cg_config in eh_config.consumer_groups : {
          namespace_name = ns_name
          eventhub_name  = eh_name
          config         = cg_config
        }
      ]
    ]
  ])

  test1 = flatten([
    for ns_name, ns_config in var.eventhub_resources : [
      for eh_name, eh_config in ns_config.eventhubs : {
        namespace_name    = ns_name
        name              = eh_name
        partition_count   = eh_config.partition_count
        message_retention = eh_config.message_retention
      }
    ]
  ])
}