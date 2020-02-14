module "webserver1" {
  source = "../modules/webserverWithZone/"

  vm_name             = "vm-web1"
  location            = var.location
  resource_group_name = "RG-Web1"
  setup_script        = "../scripts/install_apache.sh"
  zone                = 1
  subnet_id           = azurerm_subnet.web.id
}

module "webserver2" {
  source = "../modules/webserverWithZone/"

  vm_name             = "vm-web2"
  location            = var.location
  resource_group_name = "RG-Web2"
  setup_script        = "../scripts/install_apache.sh"
  zone                = 2
  subnet_id           = azurerm_subnet.web.id
}

module "webserver3" {
  source = "../modules/webserverWithZone/"

  vm_name             = "vm-web3"
  location            = var.location
  resource_group_name = "RG-Web3"
  setup_script        = "../scripts/install_apache.sh"
  zone                = 3
  subnet_id           = azurerm_subnet.web.id
}