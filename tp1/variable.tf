variable "subscription" {}
variable "resource_group_name" {}
variable "location" {
  default = "West Europe"
}

variable "vnet_name" {}
variable "vnet_address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {}
variable "subnet_address_prefixes" {
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "nic_name" {}
variable "availability_set_name" {}
variable "vm_name" {}
variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {}
variable "admin_password" {}

