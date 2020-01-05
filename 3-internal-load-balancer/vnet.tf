locals {
  vnet-resource-group = "1-Vnet"

  web-vnet-name          = "vnet-web"
  web-vnet-address-space = "192.168.0.0/20"

  frontend-subnet-name           = "subnet-frontend"
  frontend-subnet-address-prefix = "192.168.0.0/24"
  backend-subnet-name           = "subnet-frontend"
  backend-subnet-address-prefix = "192.168.1.0/24"
}

resource "azurerm_resource_group" "vnet" {
  name     = local.vnet-resource-group
  location = var.location
}

resource "azurerm_virtual_network" "web" {
  name                = local.web-vnet-name
  address_space       = [local.web-vnet-address-space]
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_subnet" "frontend" {
  name                 = local.frontend-subnet-name
  address_prefix       = local.frontend-subnet-address-prefix
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.web.name
}

resource "azurerm_subnet" "backend" {
  name                 = local.backend-subnet-name
  address_prefix       = local.backend-subnet-address-prefix
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.web.name
}
