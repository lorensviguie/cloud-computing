terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
  }

#   backend "azurerm" {
    
#   }
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
  skip_provider_registration = true
}

# RG
resource "azurerm_resource_group" "my_rg" {
  name     = var.resource_group_name
  location = var.location
}

# VNET
resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

# Subnet
resource "azurerm_subnet" "my_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# NIC
resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "${var.nic_name}Conf"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Availability Set
resource "azurerm_availability_set" "my_avset" {
  name                = var.availability_set_name
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
}

# VM
resource "azurerm_virtual_machine" "my_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.my_rg.name
  location              = azurerm_resource_group.my_rg.location
  availability_set_id   = azurerm_availability_set.my_avset.id
  network_interface_ids = [azurerm_network_interface.my_nic.id]

  vm_size               = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202209200"
  }

  storage_os_disk {
    name              = "${var.vm_name}OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
