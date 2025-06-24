resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-${var.environment}-network"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}-${var.environment}"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_integration" {
  name                 = "snet-integr-${var.prefix}-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  # example: "10.1.1.0/24"
  address_prefixes     = [var.subnet_integration_prefix]
  delegation {
    name = "delegation-webapp"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet" "subnet_mysql" {
  name                 = "snet-mysql-${var.prefix}-${var.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_mysql_prefix]
  # Pas de délégation nécessaire directement pour MySQL Flexible, mais on utilisera delegated_subnet_id
  # On peut ajouter service endpoints si besoin
}