# On importe les variables communes en haut
variable "prefix" {
  type = string
}
variable "location" {
  type = string
}
variable "environment" {
  type = string
}
# Variables réseau
variable "vnet_address_space" {
  type = list(string)
}
variable "subnet_integration_prefix" {
  type = string
}
variable "subnet_mysql_prefix" {
  type = string
}
# Variables MySQL
variable "mysql_administrator_login" {
  type = string
}
variable "mysql_administrator_password" {
  type = string
  sensitive = true
}
# Variables image Docker
variable "image_name" {
  type = string
}
variable "image_tag" {
  type = string
}
# App Service Plan SKU
variable "app_service_plan_sku" {
  type = string
  default = "B1"
}