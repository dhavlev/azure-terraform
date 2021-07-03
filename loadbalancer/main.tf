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


# LB - LOGIC
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

resource "azurerm_lb_backend_address_pool" "logic" {
  name            = "logic"
  loadbalancer_id = azurerm_lb.logic.id
}

resource "azurerm_network_interface_backend_address_pool_association" "logic1" {
  network_interface_id    = var.azurerm_network_interface_logic1
  ip_configuration_name   = "logic1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.logic.id
}

resource "azurerm_lb_probe" "logic" {
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.logic.id
  name                = "web-3000"
  port                = 22
}

resource "azurerm_lb_rule" "logic" {
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.logic.id
  name                           = "logic"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.logic.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.logic.id
  probe_id                       = azurerm_lb_probe.logic.id
}

# LB - DATA
resource "azurerm_lb" "data" {
  name                = "data"
  sku                 = "Basic"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.azurerm_resource_group_name

  frontend_ip_configuration {
    name                          = "data"
    subnet_id                     = var.azurerm_subnet_data
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "data" {
  name            = "data"
  loadbalancer_id = azurerm_lb.data.id
}

resource "azurerm_network_interface_backend_address_pool_association" "data1" {
  network_interface_id    = var.azurerm_network_interface_data1
  ip_configuration_name   = "data1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.data.id
}

resource "azurerm_lb_probe" "data" {
  resource_group_name = var.azurerm_resource_group_name
  loadbalancer_id     = azurerm_lb.data.id
  name                = "sql-3306"
  port                = 22
}

resource "azurerm_lb_rule" "data" {
  resource_group_name            = var.azurerm_resource_group_name
  loadbalancer_id                = azurerm_lb.data.id
  name                           = "data"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.data.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.data.id
  probe_id                       = azurerm_lb_probe.data.id
}