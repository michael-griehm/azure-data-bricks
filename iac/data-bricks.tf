resource "azurerm_databricks_workspace" "dbx" {
  name                        = local.fqrn
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  sku                         = "standard"
  tags                        = var.tags
  managed_resource_group_name = "${data.azurerm_resource_group.rg.name}-managed"
}