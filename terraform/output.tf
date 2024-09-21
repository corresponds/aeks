output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.mysql.name
}

# output "app_gateway_public_ip" {
#   value = azurerm_public_ip.app_gateway_public_ip.ip_address
# }
