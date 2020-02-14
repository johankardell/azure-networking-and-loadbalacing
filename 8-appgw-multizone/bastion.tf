locals {
  pip-name     = "pip-bastion"
  bastion-name = "bastion-sample"
}

resource "azurerm_public_ip" "bastion" {
  name                = local.pip-name
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = local.bastion-name
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}