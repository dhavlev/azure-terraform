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

# RESOURCE GROUP
resource "azurerm_resource_group" "classic_app" {
  name     = "classic-app"
  location = var.azurerm_resource_group_location
}

# DDOS PROTECTION
resource "azurerm_network_ddos_protection_plan" "classic_app" {
  name                = "classic-app"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}

# SECURITY GROUPS
resource "azurerm_network_security_group" "gateway" {
  name                = "gateway"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}

resource "azurerm_network_security_group" "management" {
  name                = "management"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}

resource "azurerm_network_security_group" "web" {
  name                = "web"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}

resource "azurerm_network_security_group" "logic" {
  name                = "logic"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}

resource "azurerm_network_security_group" "data" {
  name                = "data"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
}


# SECURITY RULES
resource "azurerm_network_security_rule" "gateway_http" {
  name                        = "http_80"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.64/26"
  resource_group_name         = azurerm_resource_group.classic_app.name
  network_security_group_name = azurerm_network_security_group.gateway.name
}

resource "azurerm_network_security_rule" "management_ssh" {
  name                        = "ssh_22"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.classic_app.name
  network_security_group_name = azurerm_network_security_group.management.name
}

resource "azurerm_network_security_rule" "web_http" {
  name                         = "web_80"
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = [80, 22]
  source_address_prefix        = "10.0.0.0/27"
  destination_address_prefixes = ["10.0.0.128/26", "10.0.0.32/27"]
  resource_group_name          = azurerm_resource_group.classic_app.name
  network_security_group_name  = azurerm_network_security_group.web.name
}

resource "azurerm_network_security_rule" "logic_http" {
  name                         = "http_3000"
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = [3000, 22]
  source_address_prefix        = "10.0.0.64/26"
  destination_address_prefixes = ["10.0.0.192/26", "10.0.0.32/27"]
  resource_group_name          = azurerm_resource_group.classic_app.name
  network_security_group_name  = azurerm_network_security_group.logic.name
}

resource "azurerm_network_security_rule" "data_http" {
  name                         = "sql_3306"
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = [3306, 22]
  source_address_prefix        = "10.0.0.128/26"
  destination_address_prefixes = ["10.0.0.192/26", "10.0.0.32/27"]
  resource_group_name          = azurerm_resource_group.classic_app.name
  network_security_group_name  = azurerm_network_security_group.data.name
}

# gateway: 10.0.0.0/27
# management: 10.0.0.32/27
# web: 10.0.0.64/26
# logic: 10.0.0.128/26
# data: 10.0.0.192/26


# SUBNETS
resource "azurerm_subnet" "gateway" {
  name                 = "gateway"
  resource_group_name  = azurerm_resource_group.classic_app.name
  virtual_network_name = azurerm_virtual_network.classic_app.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.classic_app.name
  virtual_network_name = azurerm_virtual_network.classic_app.name
  address_prefixes     = ["10.0.0.32/27"]
}

resource "azurerm_subnet" "web" {
  name                 = "web"
  resource_group_name  = azurerm_resource_group.classic_app.name
  virtual_network_name = azurerm_virtual_network.classic_app.name
  address_prefixes     = ["10.0.0.64/26"]
}

resource "azurerm_subnet" "logic" {
  name                 = "logic"
  resource_group_name  = azurerm_resource_group.classic_app.name
  virtual_network_name = azurerm_virtual_network.classic_app.name
  address_prefixes     = ["10.0.0.128/26"]
}

resource "azurerm_subnet" "data" {
  name                 = "data"
  resource_group_name  = azurerm_resource_group.classic_app.name
  virtual_network_name = azurerm_virtual_network.classic_app.name
  address_prefixes     = ["10.0.0.192/26"]
}

# ASSOCIATION - SUBNET AND NSG
resource "azurerm_subnet_network_security_group_association" "gateway_http" {
  subnet_id                 = azurerm_subnet.gateway.id
  network_security_group_id = azurerm_network_security_group.gateway.id
}

resource "azurerm_subnet_network_security_group_association" "management_ssh" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "web_http" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "logic_http" {
  subnet_id                 = azurerm_subnet.logic.id
  network_security_group_id = azurerm_network_security_group.logic.id
}

resource "azurerm_subnet_network_security_group_association" "data_http" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "classic_app" {
  name                = "classic-app"
  resource_group_name = azurerm_resource_group.classic_app.name
  location            = azurerm_resource_group.classic_app.location
  address_space       = ["10.0.0.0/24"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.classic_app.id
    enable = true
  }
}

# LOADBALANCER
#resource "azurerm_lb" "logic" {
#  name                = "logic"
#  sku                 = "Basic"
#  location            = azurerm_resource_group.classic_app.location
#  resource_group_name = azurerm_resource_group.classic_app.name
#
#  frontend_ip_configuration {
#    name                          = "logic"
#    subnet_id                     = azurerm_subnet.logic.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
#
#resource "azurerm_lb" "web" {
#  name                = "web"
#  sku                 = "Basic"
#  location            = azurerm_resource_group.classic_app.location
#  resource_group_name = azurerm_resource_group.classic_app.name
#
#  frontend_ip_configuration {
#    name                          = "web"
#    subnet_id                     = azurerm_subnet.web.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}

# BASTION HOST

resource "azurerm_public_ip" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name
  allocation_method   = "Dynamic"
}


resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.classic_app.location
  resource_group_name = azurerm_resource_group.classic_app.name

  ip_configuration {
    name                 = "bastion"
    subnet_id            = azurerm_subnet.management.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}