# Provider et variables communes
terraform {
  required_version = ">= 1.0"
}
provider "azurerm" {
  features {}
}

# Modules
module "network" {
  source       = "../../modules/network"
  prefix       = var.prefix
  environment  = var.environment
  location     = var.location
  vnet_address_space       = var.vnet_address_space
  subnet_integration_prefix = var.subnet_integration_prefix
  subnet_mysql_prefix      = var.subnet_mysql_prefix
}

module "acr" {
  source              = "../../modules/acr"
  prefix              = var.prefix
  environment         = var.environment
  location            = var.location
  resource_group_name = module.network.resource_group_name
}

module "mysql" {
  source               = "../../modules/mysql"
  prefix               = var.prefix
  environment          = var.environment
  location             = var.location
  resource_group_name  = module.network.resource_group_name
  delegated_subnet_id  = module.network.subnet_mysql_id
  mysql_administrator_login    = var.mysql_administrator_login
  mysql_administrator_password = var.mysql_administrator_password
}

module "webapp" {
  source              = "../../modules/webapp"
  prefix              = var.prefix
  environment         = var.environment
  location            = var.location
  resource_group_name = module.network.resource_group_name
  app_service_plan_sku = var.app_service_plan_sku
  acr_login_server    = module.acr.acr_login_server
  acr_resource_id     = module.acr.acr_id
  image_name          = var.image_name
  image_tag           = var.image_tag
  subnet_integration_id = module.network.subnet_integration_id
  mysql_fqdn_private  = module.mysql.mysql_fqdn_private
  mysql_username      = module.mysql.mysql_username
  mysql_password      = module.mysql.mysql_password
}