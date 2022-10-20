## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>0.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>0.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.aca](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.aca_env](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_application_gateway.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/application_gateway) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_network_ddos_protection_plan.ddos](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_postgresql_server.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/postgresql_server) | resource |
| [azurerm_private_dns_a_record.dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.prostgresql_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.base](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.aca_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/subnet) | resource |
| [azurerm_subnet.app_gateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/subnet) | resource |
| [azurerm_subnet.prostgresql_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.6.0/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aca_env_subnet_address_prefixes"></a> [aca\_env\_subnet\_address\_prefixes](#input\_aca\_env\_subnet\_address\_prefixes) | Address prefixes for aca env subnet | `list(string)` | n/a | yes |
| <a name="input_aca_env_subnet_name"></a> [aca\_env\_subnet\_name](#input\_aca\_env\_subnet\_name) | Subnet name for application | `string` | n/a | yes |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | VNET Address space | `list(string)` | n/a | yes |
| <a name="input_app_gateway_subnet_address_prefixes"></a> [app\_gateway\_subnet\_address\_prefixes](#input\_app\_gateway\_subnet\_address\_prefixes) | Address prefixes for application gateway subnet | `list(string)` | n/a | yes |
| <a name="input_app_gateway_subnet_name"></a> [app\_gateway\_subnet\_name](#input\_app\_gateway\_subnet\_name) | Subnet name of application gateway | `string` | n/a | yes |
| <a name="input_application_gateway_name"></a> [application\_gateway\_name](#input\_application\_gateway\_name) | Name of application gateway | `string` | n/a | yes |
| <a name="input_container_apps_env_name"></a> [container\_apps\_env\_name](#input\_container\_apps\_env\_name) | Name of container apps environment name | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Image name is use in container app with this format reponame/image:tag | `string` | `"servian/techchallengeapp:latest"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Postgres password name in Azure | `string` | n/a | yes |
| <a name="input_db_subnet_address_prefixes"></a> [db\_subnet\_address\_prefixes](#input\_db\_subnet\_address\_prefixes) | Address prefixes for backend database subnet | `list(string)` | n/a | yes |
| <a name="input_db_subnet_name"></a> [db\_subnet\_name](#input\_db\_subnet\_name) | Subnet name for backend database | `string` | n/a | yes |
| <a name="input_db_user"></a> [db\_user](#input\_db\_user) | Postgres Server login name in Azure | `string` | n/a | yes |
| <a name="input_ddos_protection_plan_name"></a> [ddos\_protection\_plan\_name](#input\_ddos\_protection\_plan\_name) | Name of ddos protection plan | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of log analytics workspace | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | RG location in Azure | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | RG name in Azure | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Postgres instance name in Azure | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Specifies the tags of azure resource | `map` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | VNET name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_dns_name"></a> [public\_ip\_dns\_name](#output\_public\_ip\_dns\_name) | A public ip address where application can be browsed |
