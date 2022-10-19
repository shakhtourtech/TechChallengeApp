resource_group_name                 = "rg-servian-prod-001"
resource_group_location             = "westeurope"
server_name                         = "psql-servian-prod"
vnet_name                           = "vnet-prod-westeurope-001"
aca_env_subnet_name                 = "snet-acaenv-prod-westeurope-001"
app_gateway_subnet_name             = "snet-agw-prod-westeurope-001"
db_subnet_name                      = "snet-db-prod-westeurope-001"
application_gateway_name            = "agw-servian-prod-001"
log_analytics_workspace_name        = "law-servian-prod"
container_apps_env_name             = "cae-servian-prod"
ddos_protection_plan_name           = "ddos-servian-prod"
container_image                     = "servian/techchallengeapp:latest"
address_space                       = ["10.0.0.0/16"]
aca_env_subnet_address_prefixes     = ["10.0.2.0/23"]
app_gateway_subnet_address_prefixes = ["10.0.4.0/23"]
db_subnet_address_prefixes          = ["10.0.1.0/24"]


tags = {
  environment = "prod"
  application = "servian"
}

