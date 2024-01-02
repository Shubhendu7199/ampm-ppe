locals {
  namespace_auth_rules = flatten([
    for namespace, config in var.servicebus_resources : [
      for auth_rule_name, auth_config in config.namespace_auth_rules : {
        config         = auth_config
        namespace_name = namespace
        auth_rule_name = auth_rule_name
      }
    ]
  ])

  topic = flatten([
    for namespace, config in var.servicebus_resources : [
      for topic_name, topic_config in config.topics : [
        for auth_rule_name, auth_config in topic_config.topic_auth_rules : {
          namespace_name = namespace
          topic_name     = topic_name
          auth_rule_name = auth_rule_name
          auth_config    = auth_config
        }
      ]
    ]
  ])
}