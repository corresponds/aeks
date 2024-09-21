terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg-20240919"
    storage_account_name = "terraformstate20240919"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "60be7d5b-05a3-475b-9bb2-0d833f5b99bd"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = "Brazil South"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_application_gateway" "app_gateway" {
#   name                = "app-gateway"
#   location            = azurerm_resource_group.aks_rg.location
#   resource_group_name = azurerm_resource_group.aks_rg.name

#   sku {
#     name     = "Standard_v2"
#     tier     = "Standard_v2"
#     capacity = 2
#   }

#   gateway_ip_configuration {
#     name      = "app-gateway-ip-config"
#     subnet_id = azurerm_subnet.app_gateway_subnet.id
#   }

#   frontend_port {
#     name = "frontend-port"
#     port = 80
#   }

#   frontend_ip_configuration {
#     name                 = "frontend-ip-config"
#     public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
#   }

#   backend_address_pool {
#     name = "backend-pool"
#   }

#   http_listener {
#     name                           = "http-listener"
#     frontend_ip_configuration_name = "frontend-ip-config"
#     frontend_port_name             = "frontend-port"
#     protocol                       = "Http"
#   }

#   request_routing_rule {
#     name                       = "routing-rule"
#     rule_type                  = "Basic"
#     http_listener_name         = "http-listener"
#     backend_address_pool_name  = "backend-pool"
#     backend_http_settings_name = "http-settings"
#     priority                   = 100  # 添加优先级
#   }

#   backend_http_settings {
#     name                  = "http-settings"
#     cookie_based_affinity = "Disabled"
#     port                  = 80
#     protocol              = "Http"
#   }
# }

# resource "azurerm_public_ip" "app_gateway_public_ip" {
#   name                = "app-gateway-public-ip"
#   location            = azurerm_resource_group.aks_rg.location
#   resource_group_name = azurerm_resource_group.aks_rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard" 
# }

# resource "azurerm_virtual_network" "app_gateway_vnet" {
#   name                = "app-gateway-vnet"
#   location            = azurerm_resource_group.aks_rg.location
#   resource_group_name = azurerm_resource_group.aks_rg.name
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "app_gateway_subnet" {
#   name                 = "app-gateway-subnet"
#   resource_group_name  = azurerm_virtual_network.app_gateway_vnet.resource_group_name
#   virtual_network_name = azurerm_virtual_network.app_gateway_vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = var.mysql_server_name
  location               = azurerm_resource_group.aks_rg.location
  resource_group_name    = azurerm_resource_group.aks_rg.name
  sku_name               = "B_Standard_B1s"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = 7
}

resource "azurerm_mysql_flexible_database" "mysql_db" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
