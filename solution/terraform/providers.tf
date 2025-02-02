provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.6.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>0.4.0"
    }
  }
}



provider "azapi" {}