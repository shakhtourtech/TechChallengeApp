variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of log analytics workspace"
}

variable "ddos_protection_plan_name" {
  type        = string
  description = "Name of ddos protection plan"
}

variable "container_apps_env_name" {
  type        = string
  description = "Name of container apps environment name"
}
variable "server_name" {
  type        = string
  description = "Postgres instance name in Azure"
}


variable "db_user" {
  type        = string
  description = "Postgres Server login name in Azure"
}

variable "db_password" {
  type        = string
  description = "Postgres password name in Azure"
}

variable "container_image" {
  type        = string
  description = "Image name is use in container app with this format reponame/image:tag"
  default     = "servian/techchallengeapp:latest"
}


variable "vnet_name" {
  description = "VNET name"
  type        = string
}

variable "address_space" {
  description = "VNET Address space"
  type        = list(string)
}

variable "aca_env_subnet_name" {
  description = "Subnet name for application"
  type        = string
}

variable "aca_env_subnet_address_prefixes" {
  description = "Address prefixes for aca env subnet"
  type        = list(string)
}
variable "app_gateway_subnet_name" {
  description = "Subnet name of application gateway"
  type        = string
}

variable "app_gateway_subnet_address_prefixes" {
  description = "Address prefixes for application gateway subnet"
  type        = list(string)
}
variable "db_subnet_name" {
  description = "Subnet name for backend database"
  type        = string
}

variable "db_subnet_address_prefixes" {
  description = "Address prefixes for backend database subnet"
  type        = list(string)
}
variable "application_gateway_name" {
  description = "Name of application gateway"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of azure resource"
  default     = {}
}

