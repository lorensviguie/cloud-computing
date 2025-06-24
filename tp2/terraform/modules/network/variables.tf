variable "prefix" {
  type = string
}
variable "environment" {
  type = string
}
variable "location" {
  type = string
}
# Address space pour VNet (ex: 10.1.0.0/16 pour dev, 10.2.0.0/16 pour prod, fourni dans env.tfvars)
variable "vnet_address_space" {
  type = list(string)
}
# Prefix pour subnets: on peut fournir
variable "subnet_integration_prefix" {
  type = string
}
variable "subnet_mysql_prefix" {
  type = string
}