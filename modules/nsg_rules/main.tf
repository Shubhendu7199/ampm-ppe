resource "azurerm_network_security_rule" "example" {
  for_each                    = flatten([for nsg_name, nsg in var.nsg_rules : [for rule_name, rule in nsg : { nsg_name = nsg_name, rule_name = rule_name, rule = rule }]])
  name                        = "${each.value.nsg_name}-${each.value.rule_name}"
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = data.azurerm_network_security_group[each.value.nsg_name].example
}