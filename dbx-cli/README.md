# Databricks CLI Setup

This documents the steps to setup the Databricks CLI.

## Install Python

Download the installer for Windows from here:  <https://www.python.org/downloads/release/python-3103/>

When installing, be sure to select the options:

- py launcher
- Add Python to environment variables

To set these options, you might need to Modify the install after initial Install.

## Install PIP

Run the following shell command

    pip install databricks-cli

## Generate DBx Personal Access Token

- In the Databricks workspace UI, click on the Settings (gear) icon in the lower left hand corner.
- Click 'User Settings'.
- Go to the 'Access Tokens' tab.
- Click the Generate New Token button.

## Configure the CLI to use a Personal Access Token

    databricks configure --token

## Create the Key Vault Secret Scope

    databricks secrets create-scope --scope "key-vault-secret-scope" --scope-backend-type AZURE_KEYVAULT --resource-id "/subscriptions/95b4e3af-639e-45a3-90d7-abbe267d6816/resourceGroups/dbx-demo-eastus2/providers/Microsoft.KeyVault/vaults/secscpcatdbxeasdem" --dns-name "https://secscpcatdbxeasdem.vault.azure.net/" --initial-manage-principal users

## List Secret Scopes

    databricks secrets list-scopes

## Delete Secret Scope

    databricks secrets delete-scope --scope my-simple-azure-keyvault-scope

## Add Secret

For Key Vault backed scope, do thru Portal, Azure CLI, or IaC.

For Databrick Backed Secret Scope:

    databricks secrets put --scope key-vault-secret-scope --key cryptoanalyticslake-access-key

## List Secrets

    databricks secrets list --scope key-vault-secret-scope

## References

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/authentication>
