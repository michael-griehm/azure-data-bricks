cd C:/Repos/github/michael-griehm/azure-databricks/dbx-secret-scope

curl --netrc --request POST \
https://adb-4588860002312821.1.azuredatabricks.net/api/2.0/secrets/scopes/create \
--header "Content-Type: application/json" \
--header "Authorization: Bearer <azure-ad-access-token-from-py-script>" \
--data @create-scope.json