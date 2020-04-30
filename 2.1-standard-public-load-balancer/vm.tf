module "webserver1" {
  source = "../modules/webserverNoPublic/"

  vm_name        = "2-vm-web1"
  location       = var.location
  resource_group = azurerm_resource_group.web
  setup_script   = "../scripts/install_apache.sh"

  subnet_id = azurerm_subnet.web.id
}

module "webserver2" {
  source = "../modules/webserverNoPublic/"

  vm_name        = "2-vm-web2"
  location       = var.location
  resource_group = azurerm_resource_group.web
  setup_script   = "../scripts/install_apache.sh"

  subnet_id = azurerm_subnet.web.id
}
