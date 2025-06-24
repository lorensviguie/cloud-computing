output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_integration_id" {
  value = azurerm_subnet.subnet_integration.id
}
output "subnet_mysql_id" {
  value = azurerm_subnet.subnet_mysql.id
}   