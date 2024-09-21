variable "resource_group_name" {
  type    = string
  default = "aks-resource-group-brz"
}

variable "location" {
  type    = string
  default = "Brazil South"
}

variable "mysql_server_name" {
  type    = string
  default = "mssql-server-brz"
}

variable "mysql_database_name" {
  type    = string
  default = "example-db-brz"
}

variable "admin_username" {
  type    = string
  default = "mysqladmin"
}

variable "admin_password" {
  type    = string
  default = "AdozooCC1234!"
}

variable "app_gateway_name" {
  type    = string
  default = "app-gateway-brz"
}

variable "vnet_name" {
  type    = string
  default = "aks-vnet-brz"
}

variable "subnet_name" {
  type    = string
  default = "aks-subnet-brz"
}
