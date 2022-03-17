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

resource "azurerm_network_security_rule" "databricks_control_plane_ssh" {
  name                        = "databricks-control-plane-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefixes     = ["23.101.152.95/32", "20.41.4.112/32"]
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "databricks_control_plane_worker_proxy" {
  name                        = "databricks-control-plane-worker-proxy"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefixes     = ["23.101.152.95/32", "20.41.4.112/32"]
  source_port_range           = "*"
  destination_port_range      = "5557"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "databricks_worker_to_worker" {
  name                        = "databricks-worker-to-worker"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.fqrn
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.139.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "public_subnet" {
  name                 = local.public_subnet
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.139.0.0/18"]

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/networkinterfaces/*",
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "private_subnet" {
  name                 = local.private_subnet
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.139.64.0/18"]

  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/networkinterfaces/*",
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_databricks_workspace" "dbx" {
  name                        = local.fqrn
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  sku                         = "standard"
  tags                        = var.tags
  managed_resource_group_name = "${data.azurerm_resource_group.rg.name}-managed"

  custom_parameters {
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    vnet_address_prefix                                  = "10.139"
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public_subnet_nsg.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private_subnet_nsg.id
    public_subnet_name                                   = local.public_subnet
    private_subnet_name                                  = local.private_subnet
  }
}