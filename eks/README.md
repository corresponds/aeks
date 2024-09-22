# eks

Create an EKS cluster integrated with ALB,Lambda,Route 53

## Terraform

``` shell
az group create --name terraform-state-rg-20240919 --location eastus
az storage account create --name terraformstate20240919 --resource-group terraform-state-rg-20240919 --location eastus --sku Standard_LRS
az storage container create --name tfstate --account-name terraformstate20240919
```

``` HCL
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-state-rg-20240919"
    storage_account_name  = "terraformstate20240919"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```


``` shell
az aks get-credentials --resource-group aks-resource-group-brz --name aks-cluster
kubectl get nodes
```