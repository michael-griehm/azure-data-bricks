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

    https://adb-4588860002312821.1.azuredatabricks.net

    <azure-ad-access-token-from-py-script>

    eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyIsImtpZCI6ImpTMVhvMU9XRGpfNTJ2YndHTmd2UU8yVnpNYyJ9.eyJhdWQiOiIyZmY4MTRhNi0zMzA0LTRhYjgtODVjYi1jZDBlNmY4NzljMWQiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9mNGNiNGMzOC1kN2Q0LTRjMGYtODg4Yy0wNWUwY2U0ZDc0MzcvIiwiaWF0IjoxNjQ3NjM4NTg0LCJuYmYiOjE2NDc2Mzg1ODQsImV4cCI6MTY0NzY0MzA5NywiYWNyIjoiMSIsImFpbyI6IkFUUUF5LzhUQUFBQVhtZ0ZySTJnVVcwTkZBbFM1ZUNScG52d1RRZ0FyM2RvTDQ0cmtVTzhkeDJ3WmFJR1hER3I5T2NqNWJxM092V3YiLCJhbXIiOlsicHdkIl0sImFwcGlkIjoiZDUwMDU5NjUtZDE0Ni00YmE4LWJjNWUtN2MyNzM0NzNmNGUxIiwiYXBwaWRhY3IiOiIwIiwiZmFtaWx5X25hbWUiOiJHcmllaG0iLCJnaXZlbl9uYW1lIjoiTWljaGFlbCIsImlwYWRkciI6IjI0LjMxLjE3MS45OCIsIm5hbWUiOiJNaWNoYWVsIEdyaWVobSIsIm9pZCI6ImJlYTdmZDNhLTMyODQtNDIwYi1hOTdjLTYyNDU2NmM0OWNhYiIsInB1aWQiOiIxMDAzMjAwMTJBMTg3Q0VCIiwicmgiOiIwLkFRMEFPRXpMOU5UWEQweUlqQVhnemsxME42WVUtQzhFTTdoS2hjdk5EbS1IbkIwTkFBSS4iLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzdWIiOiJZcUV2ZUVsZWs5N1VDOXotOGh4RXBZdmIyREwtZnFYaDFGZW51eGUwdWhVIiwidGlkIjoiZjRjYjRjMzgtZDdkNC00YzBmLTg4OGMtMDVlMGNlNGQ3NDM3IiwidW5pcXVlX25hbWUiOiJtaWtlZ0Bpc2gtc3Rhci5jb20iLCJ1cG4iOiJtaWtlZ0Bpc2gtc3Rhci5jb20iLCJ1dGkiOiItTnZEZGtiQjNrS2Z6bWl1Nm9ZX0FBIiwidmVyIjoiMS4wIn0.QJg39iC9oFA3vtqdMd_rWzPtw_rqKG-XJqdzYREAvac0bNmhgr5RNMQCQWEL8E-69lR5RB4XvYWVrqgzm6_Ykrxbd-Xg4uNCW4LRQs7g1GbuWWQLLUXxfhYGDYKrRAvFT1HTlFye1K6cRThLWWRZVKk2XYFLtEClj1OjpaREekMG4hGIR1aWVLUC-76MePmF5LqHArHz_w3e8YneEsE4vzQBWAIqjP3SVRC2R8C9GoSvita883Ea-L6jLxfzGQ6J1ckBHWan4gnA-oAlXj8jt4P_eFfRLo5ohvuJu2b5-Y_huf9bqg_f5zjCIXAONRASYsX7ql8gqkY4xrALZPx-TQ

## Create the Key Vault Secret Scope

    databricks secrets create-scope --scope "key-vault-secret-scope" --scope-backend-type AZURE_KEYVAULT --resource-id "/subscriptions/95b4e3af-639e-45a3-90d7-abbe267d6816/resourceGroups/dbx-demo-eastus2/providers/Microsoft.KeyVault/vaults/sscatdbxeasdem" --dns-name "https://sscatdbxeasdem.vault.azure.net/" --initial-manage-principal users

## List Secret Scopes

    databricks secrets list-scopes

## Delete Secret Scope

    databricks secrets delete-scope --scope my-simple-azure-keyvault-scope

## Add Secret

For Key Vault backed scope, do thru Portal, Azure CLI, or IaC.

For Databrick Backed Secret Scope:

    databricks secrets put --scope key-vault-secret-scope --key cryptoanalyticslake

## List Secrets

    databricks secrets list --scope key-vault-secret-scope

## References

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/authentication>
