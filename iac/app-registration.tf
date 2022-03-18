resource "azuread_application" "example" {
  display_name     = "${var.app_name}-app-registration"
  owners           = [data.azurerm_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  public_client {
    redirect_uris = ["http://localhost"]
  }

  required_resource_access {
    resource_app_id = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d" # Azure DBx

    resource_access {
      id   = "739272be-e143-11e8-9f32-f2801f1b9fd1" # user_impersonation
      type = "Role"
    }
  }
}