locals {
  nicname        = "nic-${var.vm_name}"
  vmsize         = "Standard_B2ms"
  osdisk_name    = "osdisk-${var.vm_name}"
  admin_username = "johan"
  ssh_key        = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_resource_group" "web" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "web" {
  name                = "pip-${var.vm_name}"
  resource_group_name = azurerm_resource_group.web.name
  location            = azurerm_resource_group.web.location
  allocation_method   = "Dynamic"
  zones               = [var.zone]
}

resource "azurerm_network_interface" "web" {
  name                = local.nicname
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

resource "azurerm_virtual_machine" "web" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.web.id]
  vm_size               = local.vmsize
  zones                 = [var.zone]

  storage_os_disk {
    name              = local.osdisk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19.10-DAILY"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = local.admin_username
    custom_data    = file(var.setup_script)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = local.ssh_key
      path     = "/home/${local.admin_username}/.ssh/authorized_keys"
    }
  }
}
