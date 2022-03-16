terraform {
  required_providers {
    azurerm = "~> 2.33"
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
    environment = "demo"
    workload    = "crypto-analytics"
  }
}

locals {
  loc            = lower(replace(var.location, " ", ""))
  a_name         = replace(var.app_name, "-", "")
  fqrn           = "${var.app_name}-${var.env}-${local.loc}"
  fqrn_condensed = "${length(local.a_name) > 22 ? substr(local.a_name, 0, 22) : local.a_name}${substr(local.loc, 0, 1)}${substr(var.env, 0, 1)}"
  rg_name        = local.fqrn
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = local.rg_name
}