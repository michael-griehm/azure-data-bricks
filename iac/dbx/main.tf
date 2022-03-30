terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }

    databricks = {
      source = "databrickslabs/databricks"
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

variable "env" {
  default   = "demo"
  sensitive = false
}

variable "location" {
  default   = "East US 2"
  sensitive = false
  type      = string
}

variable "admin_user_principal_name" {
  type        = string
  sensitive   = true
  description = "The user principal name of the admin for the app."
  default     = "mikeg@ish-star.com"
}

variable "client_secret" {
  type      = string
  sensitive = true
}

locals {
  loc    = lower(replace(var.location, " ", ""))
  a_name = replace(var.app_name, "-", "")
  fqrn   = "${var.app_name}-${var.env}-${local.loc}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "dbx-demo-eastus2"
}

data "azuread_user" "admin" {
  user_principal_name = var.admin_user_principal_name
}