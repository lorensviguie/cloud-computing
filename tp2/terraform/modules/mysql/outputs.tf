output "mysql_fqdn_private" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}
output "mysql_username" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}
output "mysql_password" {
  value     = azurerm_mysql_flexible_server.mysql.administrator_password
  sensitive = true
}