resource "azurerm_network_security_rule" "example" {
  for_each = { for rule in local.nsg_rule : "${rule.nsg_name}-${rule.rule_name}" => rule }
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
  network_security_group_name = data.azurerm_network_security_group.example[each.value.nsg_name].name
}