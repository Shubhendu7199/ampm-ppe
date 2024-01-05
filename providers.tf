provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.7.0"
    }
    tfe = {
      version = "0.27.0"
    }
  }
}

terraform {
  cloud {
    organization = "Shubhendu"

    workspaces {
      name = "cartier"
    }
  }
}