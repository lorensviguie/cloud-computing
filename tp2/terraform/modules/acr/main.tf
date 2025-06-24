resource "azurerm_container_registry" "acr" {
  name                = "acr${var.prefix}${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  admin_enabled       = false
}