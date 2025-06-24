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
# Subnet délégué pour MySQL Flexible
variable "delegated_subnet_id" {
  type = string
}
# Admin credentials (stockez idealement en Key Vault ou TF var secure)
variable "mysql_administrator_login" {
  type = string
}
variable "mysql_administrator_password" {
  type = string
  sensitive = true
}
# SKU: ex: Standard_B1ms, Standard_B2ms...
variable "mysql_sku_name" {
  type    = string
  default = "Standard_B1ms"
}
# Version MySQL, ex: "8.0"
variable "mysql_version" {
  type    = string
  default = "8.0"
}
# Storage size en Go
variable "storage_mb" {
  type    = number
  default = 51200 # 50 Go
}