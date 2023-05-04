output connection_string {
  value       = "Server=tcp:${random_pet.service.id}-server.database.windows.net,1433;Initial Catalog=owaspdb;Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  sensitive   = true 
}
