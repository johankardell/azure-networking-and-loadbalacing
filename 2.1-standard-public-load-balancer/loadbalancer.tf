resource "azurerm_public_ip" "loadbalancer" {
  name                = "2-pip-public-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.loadbalancer.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "public" {
  name                = "2-lb-public"
  location            = var.location
  resource_group_name = azurerm_resource_group.loadbalancer.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.loadbalancer.id
  }
}

resource "azurerm_lb_rule" "web" {
  resource_group_name            = azurerm_resource_group.loadbalancer.name
  loadbalancer_id                = azurerm_lb.public.id
  name                           = "Web"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
  probe_id                       = azurerm_lb_probe.web.id
}

#These doesn't seem to be working i Terraform - cannot assign backend target
# resource "azurerm_lb_nat_rule" "ssh1" {
#   resource_group_name            = azurerm_resource_group.loadbalancer.name
#   loadbalancer_id                = azurerm_lb.public.id
#   name                           = "SSHAccess"
#   protocol                       = "Tcp"
#   frontend_port                  = 221
#   backend_port                   = 22
#   frontend_ip_configuration_name = "PublicIPAddress"
#   # backend_ip_configuration_id    = module.webserver1.ipconfig_id.id
# }

# resource "azurerm_lb_nat_rule" "ssh2" {
#   resource_group_name            = azurerm_resource_group.loadbalancer.name
#   loadbalancer_id                = azurerm_lb.public.id
#   name                           = "SSHAccess2"
#   protocol                       = "Tcp"
#   frontend_port                  = 222
#   backend_port                   = 22
#   frontend_ip_configuration_name = "PublicIPAddress"
#   # backend_ip_configuration_id    = module.webserver2.ipconfig_id.id
# }

resource "azurerm_lb_probe" "web" {
  interval_in_seconds = 5
  loadbalancer_id     = azurerm_lb.public.id
  name                = "web"
  number_of_probes    = 2
  port                = 80
  # request_path        = "/"
  # timeouts            = 5
  resource_group_name = azurerm_resource_group.loadbalancer.name
}

resource "azurerm_lb_backend_address_pool" "pool" {
  resource_group_name = azurerm_resource_group.loadbalancer.name
  loadbalancer_id     = azurerm_lb.public.id
  name                = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "web1" {
  network_interface_id    = module.webserver1.nic_id
  ip_configuration_name   = "ipconfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web2" {
  network_interface_id    = module.webserver2.nic_id
  ip_configuration_name   = "ipconfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}
