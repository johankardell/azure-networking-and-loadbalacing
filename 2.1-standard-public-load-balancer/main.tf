resource "azurerm_resource_group" "web" {
  name     = "2-1-webservers"
  location = var.location
}

resource "azurerm_resource_group" "loadbalancer" {
  name     = "2-1-Loadbalancer"
  location = var.location
}