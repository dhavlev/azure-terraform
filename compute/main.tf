terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.26"
    }
  }

  required_version = ">=0.14.9"
}

provider "azurerm" {
  features {}
}

# NIC
resource "azurerm_network_interface" "web1" {
  name                = "web1"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "web1"
    subnet_id                     = var.azurerm_subnet_web
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "web2" {
  name                = "web2"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "web2"
    subnet_id                     = var.azurerm_subnet_web
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "logic1" {
  name                = "logic1"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "logic1"
    subnet_id                     = var.azurerm_subnet_logic
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "logic2" {
  name                = "logic2"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "logic2"
    subnet_id                     = var.azurerm_subnet_logic
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "data1" {
  name                = "data1"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = "data1"
    subnet_id                     = var.azurerm_subnet_data
    private_ip_address_allocation = "Dynamic"
  }
}

# VIRTUAL MACHINES
resource "azurerm_linux_virtual_machine" "web1" {
  name                = "web1"
  resource_group_name = var.azurerm_resource_group_name
  admin_username      = "azureuser"
  location            = var.azurerm_resource_group_location
  size                = "Standard_B1ls"
  zone                = "2"

  network_interface_ids = [azurerm_network_interface.web1.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.ubuntu_version
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./compute/vm-access.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

#resource "azurerm_linux_virtual_machine" "web2" {
#  name                = "web2"
#  resource_group_name = var.azurerm_resource_group_name
#  admin_username      = "azureuser"
#  location            = var.azurerm_resource_group_location
#  size                = "Standard_B1ls"
#  zone                = "3"
#
#  network_interface_ids = [azurerm_network_interface.web2.id]
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = var.ubuntu_version
#    version   = "latest"
#  }
#
#  admin_ssh_key {
#    username   = "azureuser"
#    public_key = file("./compute/vm-access.pub")
#  }
#
#  os_disk {
#    caching              = "ReadWrite"
#    storage_account_type = "Standard_LRS"
#  }
#}

resource "azurerm_linux_virtual_machine" "logic1" {
  name                = "logic1"
  resource_group_name = var.azurerm_resource_group_name
  admin_username      = "azureuser"
  location            = var.azurerm_resource_group_location
  size                = "Standard_B1ls"
  zone                = "2"

  network_interface_ids = [azurerm_network_interface.logic1.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.ubuntu_version
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./compute/vm-access.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

#resource "azurerm_linux_virtual_machine" "logic2" {
#  name                = "logic2"
#  resource_group_name = var.azurerm_resource_group_name
#  admin_username      = "azureuser"
#  location            = var.azurerm_resource_group_location
#  size                = "Standard_B1ls"
#  zone                = "3"
#
#  network_interface_ids = [azurerm_network_interface.logic2.id]
#
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = var.ubuntu_version
#    version   = "latest"
#  }
#
#  admin_ssh_key {
#    username   = "azureuser"
#    public_key = file("./compute/vm-access.pub")
#  }
#
#  os_disk {
#    caching              = "ReadWrite"
#    storage_account_type = "Standard_LRS"
#  }
#}

resource "azurerm_linux_virtual_machine" "data1" {
  name                = "data1"
  resource_group_name = var.azurerm_resource_group_name
  admin_username      = "azureuser"
  location            = var.azurerm_resource_group_location
  size                = "Standard_B1ls"
  zone                = "2"

  network_interface_ids = [azurerm_network_interface.data1.id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.ubuntu_version
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("./compute/vm-access.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}