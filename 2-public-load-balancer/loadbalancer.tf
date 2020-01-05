resource "azurerm_resource_group" "loadbalancer" {
  name     = "2-Loadbalancer"
  location = var.location
}

resource "azurerm_public_ip" "loadbalancer" {
  name                = "2-pip-public-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.loadbalancer.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "public" {
  name                = "2-lb-public"
  location            = var.location
  resource_group_name = azurerm_resource_group.loadbalancer.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.loadbalancer.id
  }
}

resource "azurerm_lb_backend_address_pool" "pool" {
  resource_group_name = azurerm_resource_group.loadbalancer.name
  loadbalancer_id     = azurerm_lb.public.id
  name                = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "web1" {
  network_interface_id    = module.webserver1.nic_id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web2" {
  network_interface_id    = module.webserver2.nic_id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}