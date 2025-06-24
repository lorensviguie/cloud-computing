terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # backend peut être configuré ici ou laissé local
  # backend "azurerm" {
  #   resource_group_name  = "<tfstate-rg>"
  #   storage_account_name = "<tfstate-sa>"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}