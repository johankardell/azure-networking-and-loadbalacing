locals {
  nicname        = "nic-${var.vm_name}"
  vmsize         = "Standard_B2s"
  osdisk_name    = "osdisk-${var.vm_name}"
  admin_username = "johan"
  ssh_key        = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_interface" "web" {
  name                = local.nicname
  location            = var.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "web" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.web.id]
  vm_size               = local.vmsize

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
