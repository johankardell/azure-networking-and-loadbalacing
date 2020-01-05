locals {
  resource_grup = "2-WebServer"
}

module "webserver1" {
  source = "../modules/webserver/"

  vm_name             = "2-vm-web1"
  location            = var.location
  resource_group_name = local.resource_grup
  setup_script        = "../scripts/install_apache.sh"

  subnet_id = azurerm_subnet.web.id
}

module "webserver2" {
  source = "../modules/webserver/"

  vm_name             = "2-vm-web2"
  location            = var.location
  resource_group_name = local.resource_grup
  setup_script        = "../scripts/install_apache.sh"

  subnet_id = azurerm_subnet.web.id
}