# Random name using service
resource "random_pet" "service" {}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Resource group
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = random_pet.service.id
}

# SQL Server
resource "azurerm_mssql_server" "sqlserver" {
  administrator_login = "gis"
  # Generate a random password
  administrator_login_password = random_password.password.result
  location                     = azurerm_resource_group.rg.location
  name                         = "${random_pet.service.id}-server"
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = "12.0"
}

# SQL Database
resource "azurerm_mssql_database" "sqldb" {
  name      = "owaspdb"
  server_id = azurerm_mssql_server.sqlserver.id
}

# Allow all Azure IPs to access the SQL Server
resource "azurerm_mssql_firewall_rule" "sqlfirewall" {
  end_ip_address   = "0.0.0.0"
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
}

# Azure App Service Plan
resource "azurerm_app_service_plan" "appsvcplan" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.service.id
  resource_group_name = azurerm_resource_group.rg.name

  kind = "Windows"

  sku {
    size = "S1"
    tier = "Standard"
  }


}

# Workspace
resource "azurerm_log_analytics_workspace" "loganalytics" {
  location            = azurerm_resource_group.rg.location
  name                = random_pet.service.id
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Application Insights
resource "azurerm_application_insights" "appinsights" {
  application_type    = "web"
  location            = azurerm_resource_group.rg.location
  name                = random_pet.service.id
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id

}

# Azure App Service
resource "azurerm_app_service" "webapp" {
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.appinsights.instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = azurerm_application_insights.appinsights.connection_string
    ASPNETCORE_ENVIRONMENT                          = "Development"
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~2"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "~1"
    SnapshotDebugger_EXTENSION_VERSION              = "~1"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "~1"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "1"
  }

  location            = azurerm_resource_group.rg.location
  name                = random_pet.service.id
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appsvcplan.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${random_pet.service.id}-server.database.windows.net,1433;Initial Catalog=owaspdb;Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  }

}