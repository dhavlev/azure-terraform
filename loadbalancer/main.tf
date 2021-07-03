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
resource "azurerm_lb" "gateway" {
  name                = "gateway"
  sku                 = "Basic"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  frontend_ip_configuration {
    name                          = "gateway"
    subnet_id                     = var.azurerm_subnet_gateway
    private_ip_address_allocation = "Dynamic"
  }
}

#resource "azurerm_lb" "logic" {
#  name                = "logic"
#  sku                 = "Basic"
#  location            = var.azurerm_resource_group_location
#  resource_group_name = var.azurerm_resource_group_name
#
#  frontend_ip_configuration {
#    name                          = "logic"
#    subnet_id                     = var.azurerm_subnet_logic
#    private_ip_address_allocation = "Dynamic"
#  }
#}

resource "azurerm_lb_backend_address_pool" "web" {
  name            = "web"
  loadbalancer_id = azurerm_lb.gateway.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web1" {
  network_interface_id    = var.azurerm_network_interface_web1
  ip_configuration_name   = "web1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}

resource "azurerm_lb_probe" "web" {
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.gateway.id
  name                = "web-http"
  port                = 22
}

resource "azurerm_lb_rule" "gateway" {
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.gateway.id
  name                           = "gateway"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.gateway.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.web.id
  probe_id                       = azurerm_lb_probe.web.id
}