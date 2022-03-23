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
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
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
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# resource "azurerm_storage_account" "dbx_sa" {
#   name                      = "${local.fqrn_condensed}managedsa37"
#   resource_group_name       = data.azurerm_resource_group.rg.name
#   location                  = data.azurerm_resource_group.rg.location
#   account_kind              = "BlobStorage"
#   account_tier              = "Standard"
#   account_replication_type  = "GRS"
#   access_tier               = "Hot"
#   min_tls_version           = "TLS1_2"
#   allow_blob_public_access  = false
#   shared_access_key_enabled = true
#   is_hns_enabled            = false
#   tags                      = var.tags

#   network_rules {
#     default_action = "Allow"
#   }
# }

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
    # storage_account_name                               = azurerm_storage_account.dbx_sa.name
  }
}

output "azurerm_databricks_workspace_url" {
  value = azurerm_databricks_workspace.dbx.workspace_url
}

provider "databricks" {
  host                        = azurerm_databricks_workspace.dbx.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.dbx.id
  azure_client_id             = data.azurerm_client_config.current.client_id
  azure_tenant_id             = data.azurerm_client_config.current.tenant_id
  azure_client_secret         = var.client_secret
}

data "databricks_spark_version" "latest" {
  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}

data "databricks_node_type" "smallest" {
  local_disk = true

  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}

resource "databricks_user" "dbx_admin" {
  user_name = "admin_user_principal_name"

  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}

# resource "databricks_secret_scope" "this" {
#   name = "keyvault-managed"

#   keyvault_metadata {
#     resource_id = data.azurerm_key_vault.secret_scope_vault.id
#     dns_name    = data.azurerm_key_vault.secret_scope_vault.vault_uri
#   }
# }

resource "databricks_notebook" "create_quotes_per_day" {
  source   = "../../notebooks/create-quotes-per-day.ipynb"
  path     = "/Jobs"
  language = "PYTHON"

  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}

resource "databricks_job" "create_quotes_per_day_job" {
  name = "create-quotes-per-day-job"

  new_cluster {
    num_workers   = 1
    spark_version = data.databricks_spark_version.latest.id
    node_type_id  = data.databricks_node_type.smallest.id
  }

  notebook_task {
    notebook_path = databricks_notebook.create_quotes_per_day.path
  }

  email_notifications {
    on_start                  = [data.azuread_user.admin.user_principal_name]
    on_failure                = [data.azuread_user.admin.user_principal_name]
    on_success                = [data.azuread_user.admin.user_principal_name]
    no_alert_for_skipped_runs = true
  }

  schedule {
    quartz_cron_expression = "0 30 12 * * *"
    timezone_id            = "UTC"
  }

  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}

resource "databricks_cluster" "experiment" {
  cluster_name            = "experiment-cluster"
  spark_version           = data.databricks_spark_version.latest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 2
  }

  depends_on = [
    azurerm_databricks_workspace.dbx
  ]
}