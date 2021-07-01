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

# VIRTUAL MACHINES
resource "azurerm_linux_virtual_machine" "web1" {
    name = "web1"
    resource_group_name = ""
    admin_username = "azureuser"
    location = ""
    size = ""
    zone = ""

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    admin_ssh_key {
        username   = "azureuser"
        public_key = file("./vm-access.pub")
    }
}