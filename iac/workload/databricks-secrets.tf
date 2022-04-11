data "azurerm_storage_account" "adls" {
  name                = "cryptoanalyticslake"
  resource_group_name = "adls2-demo-eastus2"
}

data "azurerm_key_vault" "secret_scope_vault" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "secscp${length(local.a_name) > 12 ? substr(local.a_name, 0, 12) : local.a_name}${substr(local.loc, 0, 3)}${substr(var.env, 0, 3)}"
}

resource "azurerm_key_vault_secret" "datalake_access_key" {
  name         = "${data.azurerm_storage_account.adls.name}-access-key"
  value        = data.azurerm_storage_account.adls.primary_access_key
  key_vault_id = data.azurerm_key_vault.secret_scope_vault.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "snowflake_url" {
  name         = "snowflake-url"
  value        = var.snowflake_url
  key_vault_id = data.azurerm_key_vault.secret_scope_vault.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "snowflake_username" {
  name         = "snowflake-username"
  value        = var.snowflake_username
  key_vault_id = data.azurerm_key_vault.secret_scope_vault.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "snowflake_password" {
  name         = "snowflake-password"
  value        = var.snowflake_password
  key_vault_id = data.azurerm_key_vault.secret_scope_vault.id
  tags         = var.tags
}