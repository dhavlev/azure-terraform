output "azurerm_resource_group_name" {
  value = azurerm_resource_group.classic_app.name
}

output "azurerm_subnet_gateway" {
  value = azurerm_subnet.gateway.id
}

output "azurerm_subnet_management" {
  value = azurerm_subnet.management.id
}

output "azurerm_subnet_web" {
  value = azurerm_subnet.web.id
}

output "azurerm_subnet_logic" {
  value = azurerm_subnet.logic.id
}

output "azurerm_subnet_data" {
  value = azurerm_subnet.data.id
}