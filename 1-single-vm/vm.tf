locals {
  resource_grup = "1-WEBSERVER"
}

module "webserver1" {
  source = "../modules/webserver/"

  vm_name             = "vm-web1"
  location            = var.location
  resource_group_name = local.resource_grup
  setup_script        = "../scripts/install_apache.sh"

  subnet_id = azurerm_subnet.web.id
}