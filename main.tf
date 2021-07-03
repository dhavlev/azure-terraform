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

module "network" {
  source = "./network"

  azurerm_resource_group_location = var.location
}

module "compute" {
  source = "./compute"

  azurerm_resource_group_name     = module.network.azurerm_resource_group_name
  azurerm_resource_group_location = var.location
  azurerm_subnet_gateway          = module.network.azurerm_subnet_gateway
  azurerm_subnet_management       = module.network.azurerm_subnet_management
  azurerm_subnet_web              = module.network.azurerm_subnet_web
  azurerm_subnet_logic            = module.network.azurerm_subnet_logic
  azurerm_subnet_data             = module.network.azurerm_subnet_data
  ubuntu_version                  = var.ubuntu_version
}

module "loadbalancer" {
  source = "./loadbalancer"

  azurerm_resource_group_name      = module.network.azurerm_resource_group_name
  azurerm_resource_group_location  = var.location
  azurerm_subnet_gateway           = module.network.azurerm_subnet_gateway
  azurerm_subnet_management        = module.network.azurerm_subnet_management
  azurerm_subnet_web               = module.network.azurerm_subnet_web
  azurerm_subnet_logic             = module.network.azurerm_subnet_logic
  azurerm_subnet_data              = module.network.azurerm_subnet_data
  ubuntu_version                   = var.ubuntu_version
  azurerm_network_interface_web1   = module.compute.azurerm_network_interface_web1
  azurerm_network_interface_logic1 = module.compute.azurerm_network_interface_logic1
  azurerm_network_interface_data1  = module.compute.azurerm_network_interface_data1
}
