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

# LOADBALANCER
resource "azurerm_lb" "web" {
  name                = "web"
  sku                 = "Basic"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  frontend_ip_configuration {
    name                          = "web"
    subnet_id                     = var.azurerm_subnet_web
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb" "logic" {
  name                = "logic"
  sku                 = "Basic"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  frontend_ip_configuration {
    name                          = "logic"
    subnet_id                     = var.azurerm_subnet_logic
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "web"
  loadbalancer_id = azurerm_lb.web.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web1" {
  network_interface_id    = var.azurerm_network_interface_web1
  ip_configuration_name   = "web1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}
