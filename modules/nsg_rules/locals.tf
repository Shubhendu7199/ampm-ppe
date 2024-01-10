locals {
  nsg_rule = flatten([
    for nsg_name, nsg in var.nsg_rules : [
      for rule_name, rule in nsg : {
        nsg_name  = nsg_name
        rule_name = rule_name
        rule      = rule
      }
    ]
  ])
}