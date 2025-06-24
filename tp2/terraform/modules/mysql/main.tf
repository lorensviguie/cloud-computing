resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "mysql-${var.prefix}-${var.environment}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku_name               = var.mysql_sku_name
  version                = var.mysql_version
  delegated_subnet_id    = var.delegated_subnet_id
  administrator_login    = var.mysql_administrator_login
  administrator_password = var.mysql_administrator_password
  storage_mb             = var.storage_mb

  # on peut configurer backups, zone de haute dispo si besoin
  high_availability {
    mode = "Disabled"
  }
  availability_zone      = null
  backup_retention_days  = 7
  geo_redundant_backup   = "Disabled"
  auto_grow              = "Enabled"
  tier                   = "Burstable"

  depends_on = []
}
# Private DNS zone pour MySQL Flexible Private Endpoint
resource "azurerm_private_dns_zone" "mysql" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# Link VNet au Private DNS zone
data "azurerm_virtual_network" "vnet" {
  id = element(split("/subnets/", var.delegated_subnet_id), 0)
}
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "link-${var.prefix}-${var.environment}"  
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  depends_on            = [azurerm_mysql_flexible_server.mysql]
}

# Private endpoint pour MySQL Flexible
resource "azurerm_private_endpoint" "mysql_pe" {
  name                = "pe-mysql-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.delegated_subnet_id

  private_service_connection {
    name                           = "psc-mysql-${var.prefix}-${var.environment}"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
  depends_on = [azurerm_mysql_flexible_server.mysql]
}