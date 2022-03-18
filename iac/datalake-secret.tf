data "azurerm_storage_account" "adls" {
  name                = "cryptoanalyticslake"
  resource_group_name = "adls2-demo-eastus2"
}

resource "azurerm_key_vault_secret" "datalake_access_key" {
  name         = "${data.azurerm_storage_account.adls.name}-access-key"
  value        = data.azurerm_storage_account.adls.primary_access_key
  key_vault_id = azurerm_key_vault.secret_scope_vault.id
  tags         = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.current_deployer_acl
  ]
}