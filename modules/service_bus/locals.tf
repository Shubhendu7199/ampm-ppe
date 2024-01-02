locals {
  namespace_auth_rules = flatten([
    for k, v in var.servicebus_resources : [
      for u, v in v.namespace_auth_rules : {
        config         = v
        namespace_name = k
        auth_rule_name = u
      }
    ]
  ])
}