variable "prefix" {
  type = string
}
variable "environment" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "app_service_plan_sku" {
  type    = string
  default = "B1" # ou S1, selon besoins
}
variable "acr_login_server" {
  type = string
}
variable "acr_resource_id" {
  type = string
}
variable "image_name" {
  type = string
}
variable "image_tag" {
  type = string
}
# Subnet pour VNet integration (delegated)
variable "subnet_integration_id" {
  type = string
}
# MySQL private FQDN
variable "mysql_fqdn_private" {
  type = string
}
# Database credentials
variable "mysql_username" {
  type = string
}
variable "mysql_password" {
  type = string
  sensitive = true
}