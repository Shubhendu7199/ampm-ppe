resource "azurerm_public_ip" "devopspip" {
  name                = "PIPDevOpsAgent"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "devopsnic" {
  name                = "NICDevOpsAgentNIC"
  location            = azurerm_resource_group.ampm.location
  resource_group_name = azurerm_resource_group.ampm.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.SNET-APIs.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devopspip.id
  }
}

resource "tls_private_key" "devopsagent_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "private_key" {
  name            = "devopsagentvm"
  value           = tls_private_key.devopsagent_ssh.private_key_pem
  key_vault_id    = local.key_vault_id
  expiration_date = "2024-10-16T00:00:00Z"
}

resource "azurerm_linux_virtual_machine" "devopsagentvm" {
  name                  = "devopsagentvm"
  location              = azurerm_resource_group.ampm.location
  resource_group_name   = azurerm_resource_group.ampm.name
  network_interface_ids = [azurerm_network_interface.devopsnic.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "devopsagentvmosdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "devopsagentvm01"
  admin_username                  = "devopsagentadmin"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "devopsagentadmin"
    public_key = tls_private_key.devopsagent_ssh.public_key_openssh
  }
}