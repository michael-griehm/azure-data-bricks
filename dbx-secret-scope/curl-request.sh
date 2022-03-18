cd C:/Repos/github/michael-griehm/azure-databricks/dbx-secret-scope

curl --netrc --request POST \
https://adb-3560793084381069.9.azuredatabricks.net/api/2.0/secrets/scopes/create \
--header "Content-Type: application/json" \
--header "Authorization: Bearer dapid340f44d2f7116638809f59f3101500e-2" \
--header "X-Databricks-Azure-SP-Management-Token: <management-token>" \
--data @create-scope.json