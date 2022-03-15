locals {
  public_subnet  = "dbx-public"
  private_subnet = "dbx-private"
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.fqrn
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.fqrn
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.139.0.0/16"]
  tags                = var.tags

  subnet {
    name           = local.public_subnet
    address_prefix = "10.139.0.0/18"
    security_group = azurerm_network_security_group.nsg.id
  }

  subnet {
    name           = local.private_subnet
    address_prefix = "10.139.64.0/18"
    security_group = azurerm_network_security_group.nsg.id
  }
}

resource "azurerm_databricks_workspace" "dbx" {
  name                        = local.fqrn
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  sku                         = "standard"
  tags                        = var.tags
  managed_resource_group_name = "${data.azurerm_resource_group.rg.name}-managed"

  # custom_parameters {
  #   virtual_network_id                                   = azurerm_virtual_network.vnet.id
  #   vnet_address_prefix                                  = "10.139"
  #   storage_account_name                                 = local.fqrn_condensed
  #   storage_account_sku_name                             = "Standard_ZRS"
  #   public_subnet_network_security_group_association_id  = azurerm_network_security_group.nsg.id
  #   private_subnet_network_security_group_association_id = azurerm_network_security_group.nsg.id
  #   public_subnet_name                                   = local.public_subnet
  #   private_subnet_name                                  = local.private_subnet
  # }
}