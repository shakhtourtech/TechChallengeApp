locals {
  listener_name                  = "servian-http-listener"
  backend_address_pool_name      = "servian-be"
  http_setting_name              = "servian-be-setting"
  gateway_ip_configuration       = "servian-gateway-ipconfig"
  frontend_ip_configuration_name = "servian-ip-config"
  frontend_port_name             = "servian-fe"
  tags                           = var.tags
}

####################################################
#
# Azure Resource group
#
####################################################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = local.tags
}


####################################################
#
# Azure DDoS 
#
####################################################
resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = var.ddos_protection_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


####################################################
#
# Azure Database For PostgreSQL 
# The least version supported is version 10 in Azure
####################################################
resource "azurerm_postgresql_server" "postgres" {
  name                         = var.server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "10"
  administrator_login          = var.db_user
  administrator_login_password = var.db_password

  sku_name   = "GP_Gen5_4"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
  # ssl_minimal_tls_version_enforced = "TLS1_2"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


####################################################
#
# Azure log Analytics workspace to capture logs from
# Azure Container Apps
#
####################################################
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = local.tags
}


####################################################
#
# Azure Container Env with Container App
#
####################################################

resource "azapi_resource" "aca_env" {
  type                   = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id              = azurerm_resource_group.rg.id
  location               = azurerm_resource_group.rg.location
  name                   = var.container_apps_env_name
  tags                   = local.tags
  response_export_values = ["*"]

  body = jsonencode({
    properties = {

      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.law.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
        }
      },
      vnetConfiguration = {
        infrastructureSubnetId = azurerm_subnet.aca_subnet.id
        internal               = true
      },
      zoneRedundant = true
    }
  })
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "azapi_resource" "aca" {
  type                    = "Microsoft.App/containerApps@2022-03-01"
  parent_id               = azurerm_resource_group.rg.id
  location                = azurerm_resource_group.rg.location
  name                    = "servian"
  ignore_missing_property = true
  response_export_values  = ["properties.configuration.ingress"]

  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        ingress = {
          external   = true
          targetPort = 3000
        },
        secrets = [
          {
            name  = "db-user"
            value = "${var.db_user}@${azurerm_postgresql_server.postgres.name}"
          },
          {
            name  = "db-password"
            value = var.db_password
          },
          {
            name  = "db-host"
            value = azurerm_private_endpoint.prostgresql_endpoint.private_service_connection[0].private_ip_address
          }

        ]
      }
      template = {
        containers = [
          {
            name    = "main"
            image   = var.container_image
            args    = ["-c", "./TechChallengeApp serve"]
            command = ["sh"]
            env = [
              {
                name      = "VTT_DBUSER"
                secretRef = "db-user"
              },
              {
                name      = "VTT_DBPASSWORD"
                secretRef = "db-password"
              },
              {
                name      = "VTT_DBHOST"
                secretRef = "db-host"
              },
              {
                name  = "VTT_LISTENHOST"
                value = "0.0.0.0"
              }
            ]
            resources = {
              cpu    = 0.5
              memory = "1.0Gi"
            }
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 30
        }
      }
    }
  })
  tags = local.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#########################################################
#
# VNET and associated subnets
#
#########################################################

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddos.id
    enable = true
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "azurerm_subnet" "aca_subnet" {
  name                 = var.aca_env_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aca_env_subnet_address_prefixes

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = var.app_gateway_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.app_gateway_subnet_address_prefixes

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "prostgresql_subnet" {
  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.db_subnet_address_prefixes

  enforce_private_link_endpoint_network_policies = true

}

resource "azurerm_private_endpoint" "prostgresql_endpoint" {
  name                = "prostgresql-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.prostgresql_subnet.id

  private_service_connection {
    name                           = "prostgresql-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.postgres.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.prostgresql_subnet
  ]
}


####################################################
#
# Azure Application Gateway with WAF
#
####################################################

resource "azurerm_application_gateway" "appgw" {
  name                = var.application_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags
  enable_http2        = true
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  waf_configuration {
    enabled                  = true
    firewall_mode            = "Prevention"
    rule_set_type            = "OWASP"
    rule_set_version         = "3.2"
    file_upload_limit_mb     = 100
    max_request_body_size_kb = 128
  }
  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.base.id
  }

  backend_address_pool {
    name  = local.backend_address_pool_name
    fqdns = [jsondecode(azapi_resource.aca.output).properties.configuration.ingress.fqdn]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
    host_name             = jsondecode(azapi_resource.aca.output).properties.configuration.ingress.fqdn
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "servian-routing-rule"
    rule_type                  = "Basic"
    priority                   = 1
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.prostgresql_subnet,
    azurerm_private_dns_zone.dns_zone,
    azurerm_private_dns_a_record.dns_a_record
  ]
}

####################################################
#
# Public IP Address
#
####################################################

resource "azurerm_public_ip" "base" {
  name                = "servian-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  domain_name_label   = "servian"
  tags                = local.tags
}


####################################################
#
# Private DNS and dsn record of ACA env
#
####################################################
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = jsondecode(azapi_resource.aca_env.output).properties.defaultDomain
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "dns_a_record" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [jsondecode(azapi_resource.aca_env.output).properties.staticIp]
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}
