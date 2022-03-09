terraform {
  required_providers {
    azurerm = "~> 2.33"
    random  = "~> 2.2"
  }

  # backend "azurerm" {
  # }
}

provider "azurerm" {
  features {}
}

variable "app_name" {
  default   = "dbx"
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
    environment = "Demo"
  }
}

locals {
  loc            = lower(replace(var.location, " ", ""))
  a_name         = replace(var.app_name, "-", "")
  fqrn           = "${var.app_name}-${var.env}-${local.loc}"
  fqrn_no_dashes = "${local.a_name}-${var.env}-${local.loc}"
  rg_name        = "${local.fqrn}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_name
}