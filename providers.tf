terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  client_secret    = "yCf8Q~CC2BIlA4TQq3VBm~agxbi68FNWF5Krjc9V"
  client_id        = "b5dd99d9-924f-4324-8613-527032ddce11"
  subscription_id  = "eb90fc43-a12b-4ce4-bbe7-567e673307af"
  tenant_id        = "52cb412d-827e-4f78-8eee-e2ae28ffe657"

}