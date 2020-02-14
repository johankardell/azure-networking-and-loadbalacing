locals {
  backendips = ["192.168.0.4", "192.168.0.5", "192.168.0.6"]
}

resource "azurerm_resource_group" "appgw" {
  name     = "RG-APPGW"
  location = var.location
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.web.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.web.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.web.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.web.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.web.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.web.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.web.name}-rdrcfg"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-chapter-8"
  resource_group_name = azurerm_resource_group.appgw.name
  location            = azurerm_resource_group.appgw.location
  zones               = [1, 2, 3]

  sku {
    name = "Waf_V2"
    tier = "Waf_V2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 10
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = local.backendips
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = "/"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 1
    probe_name                          = "default"
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  probe {
    name                                      = "default"
    pick_host_name_from_backend_http_settings = true
    interval                                  = 1
    protocol                                  = "http"
    path                                      = "/"
    timeout                                   = "2"
    unhealthy_threshold                       = "2"
  }
}
