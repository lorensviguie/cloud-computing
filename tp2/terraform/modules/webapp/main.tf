# Web App Plan
resource "azurerm_app_service_plan" "plan" {
  name                = "plan-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = var.app_service_plan_sku
  }
}

# Web App for Containers
resource "azurerm_web_app" "app" {
  name                = "app-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_app_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    linux_fx_version = "DOCKER|${var.acr_login_server}/${var.image_name}:${var.image_tag}"
    # Always on recommended for production
    always_on = true
  }

  app_settings = {
    # Docker registry settings: utilise l'identité managée pour extraire l'image
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_login_server}"
    # On n'a pas besoin de USER/PWD si on utilise managed identity + role assignment
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    # Variables WordPress pour connexion DB
    "WORDPRESS_DB_HOST"     = var.mysql_fqdn_private
    "WORDPRESS_DB_NAME"     = "wordpress"
    "WORDPRESS_DB_USER"     = "${var.mysql_username}@${replace(var.mysql_fqdn_private, ".mysql.database.azure.com", "")}" # adapter selon format
    "WORDPRESS_DB_PASSWORD" = var.mysql_password
    "WORDPRESS_DB_CHARSET"  = "utf8"
  }

  depends_on = []
}

# Role Assignment pour que Web App managed identity puisse tirer l'image depuis ACR
data "azurerm_client_config" "current" {}
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_resource_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_web_app.app.identity.principal_id
}

# VNet Integration (Swift) pour Web App
resource "azurerm_web_app_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_web_app.app.id
  subnet_id      = var.subnet_integration_id
}