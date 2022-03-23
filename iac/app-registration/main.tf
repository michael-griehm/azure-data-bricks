terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

variable "app_name" {
  default   = "ca-t-dbx"
  type      = string
  sensitive = false
}

variable "admin_user_principal_name" {
  type        = string
  sensitive   = true
  description = "The user principal name of the admin for the app."
  default     = "mikeg@ish-star.com"
}

data "azurerm_client_config" "current" {}

data "azuread_user" "admin" {
  user_principal_name = var.admin_user_principal_name
}