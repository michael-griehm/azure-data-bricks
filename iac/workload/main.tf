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
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
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

variable "tags" {
  type = map(string)

  default = {
    environment = "demo"
    workload    = "crypto-analytics"
  }
}

variable "admin_user_principal_name" {
  type        = string
  sensitive   = true
  description = "The user principal name of the admin for the app."
  default     = "mikeg@ish-star.com"
}

locals {
  loc            = lower(replace(var.location, " ", ""))
  a_name         = replace(var.app_name, "-", "")
  fqrn           = "${var.app_name}-${var.env}-${local.loc}"
  fqrn_condensed = "${length(local.a_name) > 22 ? substr(local.a_name, 0, 22) : local.a_name}${substr(local.loc, 0, 1)}${substr(var.env, 0, 1)}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "dbx-demo-eastus2"
}

data "azuread_user" "admin" {
  user_principal_name = var.admin_user_principal_name
}