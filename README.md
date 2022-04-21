# azure-data-bricks

This repo contains examples of how to configure and deploy the Azure Databricks platform as a service offering.  It also contains examples of Python based Databricks notebooks reading and writing files within an instance of the Azure Data Lake Gen 2 service offering.

## Folder Structure



## Get Databricks API Permission Ids

    $> az ad sp show --id 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d >azure_dbx_permission_list.json

## Get DBx Service Principal Token of behalf of User

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/app-aad-token>

## Azure Data Bricks Pricing

- <https://databricks.com/product/azure-pricing>

## Databricks CLI

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/>

## Setup Key Vault Secret Scope

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/secrets>
- <https://docs.microsoft.com/en-us/azure/databricks/security/secrets/secret-scopes#create-an-azure-key-vault-backed-secret-scope-using-the-databricks-cli>
- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/#install-the-cli>
- <https://docs.microsoft.com/en-us/azure/databricks/security/secrets/secrets>

## Set Secret

- <https://docs.microsoft.com/en-us/azure/databricks/security/secrets/secrets>

## Access Azure Data Lake Gen 2 from Azure Databricks

- <https://docs.databricks.com/data/data-sources/azure/adls-gen2/azure-datalake-gen2-get-started.html>

## Convert Binary to String with DataFrame and Python

- <https://stackoverflow.com/questions/57186799/how-to-extract-columns-from-binarytype-using-pyspark-databricks>

## Avro Guide

- <https://spark.apache.org/docs/latest/sql-data-sources-avro.html#supported-types-for-spark-sql---avro-conversion>
- <https://docs.microsoft.com/en-us/azure/databricks/data/data-sources/read-avro>
- <https://docs.databricks.com/data/data-sources/read-avro.html>

## Pandas and Pythons

- <https://www.geeksforgeeks.org/python-pandas-dataframe/>
- <https://mkaz.blog/code/python-string-format-cookbook/>
- <https://www.geeksforgeeks.org/get-yesterdays-date-using-python/>
- <https://dev.to/sridharanprasanna/using-wildcards-for-folder-path-with-spark-dataframe-load-4jo7>
- <https://stackoverflow.com/questions/32233575/read-all-files-in-a-nested-folder-in-spark>

## Sort and Filter a Data Frame

- <https://sparkbyexamples.com/spark/spark-how-to-sort-dataframe-column-explained/>
- <https://sparkbyexamples.com/spark/spark-filter-rows-with-null-values/>

## PySpark Data Types

- <https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.sql.types.IntegerType.html>

## Mount Databricks to ADLS Gen 2

- <https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-use-databricks-spark>

## VS Code Tooling

- <https://code.visualstudio.com/docs/datascience/jupyter-notebooks>

## Terraform and Azure Databricks

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/terraform/>
- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/terraform/workspace-management>
- <https://www.terraform.io/cli/commands/output>

## Quartz Cron Job

- <https://www.freeformatter.com/cron-expression-generator-quartz.html>

## GitHub Actions Set Environment Variable in Step

- <https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#environment-files>

## Deltalake

- <https://docs.microsoft.com/en-us/azure/databricks/delta/delta-intro>

## References

- <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace>
- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/terraform/azure-workspace>
- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/terraform/>
- <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet>
- <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace#vnet_address_prefix>
- <https://techcommunity.microsoft.com/t5/azure-data-factory-blog/azure-databricks-activities-now-support-managed-identity/ba-p/1922818>
- <https://www.azenix.com.au/blog/databricks-on-azure-with-terraform>
