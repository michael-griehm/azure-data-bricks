data "azurerm_databricks_workspace" "dbx" {
  name                = local.fqrn
  resource_group_name = data.azurerm_resource_group.rg.name
}

provider "databricks" {
  host                        = data.azurerm_databricks_workspace.dbx.workspace_url
  azure_workspace_resource_id = data.azurerm_databricks_workspace.dbx.id
  azure_client_id             = data.azurerm_client_config.current.client_id
  azure_tenant_id             = data.azurerm_client_config.current.tenant_id
  azure_client_secret         = var.client_secret
}

data "databricks_spark_version" "latest" {}

data "databricks_node_type" "smallest" {
  local_disk = true
}

resource "databricks_user" "dbx_admin" {
  user_name = data.azuread_user.admin.user_principal_name
}

resource "databricks_notebook" "bronze_refine_quotes_today" {
  source   = "../../notebooks/bronze/refine-quotes-today.py"
  path     = "/job-notebooks/bronze/refine-quotes-today"
  language = "PYTHON"
}

resource "databricks_notebook" "silver_refine_quotes_today" {
  source   = "../../notebooks/silver/refine-quotes-today.py"
  path     = "/job-notebooks/silver/refine-quotes-today"
  language = "PYTHON"
}

resource "databricks_notebook" "gold_refine_quotes_today" {
  source   = "../../notebooks/gold/refine-quotes-today.py"
  path     = "/job-notebooks/gold/refine-quotes-today"
  language = "PYTHON"
}

resource "databricks_job" "refine_quotes_today_job" {
  name = "refine-quotes-today-job"

  job_cluster {
    job_cluster_key = "refine-quotes-today-job-cluster"

    new_cluster {
      num_workers   = 1
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }
  }

  task {
    task_key = "a_bronze"

    job_cluster_key = "refine-quotes-today-job-cluster"

    notebook_task {
      notebook_path = databricks_notebook.bronze_refine_quotes_today.path
    }
  }

  task {
    task_key = "b_silver"

    depends_on {
      task_key = "a_bronze"
    }

    job_cluster_key = "refine-quotes-today-job-cluster"

    notebook_task {
      notebook_path = databricks_notebook.silver_refine_quotes_today.path
    }
  }

  task {
    task_key = "c_gold"

    depends_on {
      task_key = "b_silver"
    }

    job_cluster_key = "refine-quotes-today-job-cluster"

    notebook_task {
      notebook_path = databricks_notebook.gold_refine_quotes_today.path
    }
  }

  email_notifications {
    on_start                  = [data.azuread_user.admin.user_principal_name]
    on_failure                = [data.azuread_user.admin.user_principal_name]
    on_success                = [data.azuread_user.admin.user_principal_name]
    no_alert_for_skipped_runs = true
  }

  schedule {
    quartz_cron_expression = "0 45 2,5,14,17,20,23, ? * * *"
    timezone_id            = "UTC"
  }
}

resource "databricks_cluster" "experiment" {
  cluster_name            = "experiment-cluster"
  spark_version           = data.databricks_spark_version.latest.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 10

  autoscale {
    min_workers = 1
    max_workers = 2
  }
}

data "azurerm_key_vault" "secret_scope_vault" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "secscp${length(local.a_name) > 12 ? substr(local.a_name, 0, 12) : local.a_name}${substr(local.loc, 0, 3)}${substr(var.env, 0, 3)}"
}

output "azurerm_databricks_workspace_url" {
  value = data.azurerm_databricks_workspace.dbx.workspace_url
}

output "secret_scope_vault_id" {
  value = data.azurerm_key_vault.secret_scope_vault.id
}

output "secret_scope_vault_hostname" {
  value = data.azurerm_key_vault.secret_scope_vault.vault_uri
}