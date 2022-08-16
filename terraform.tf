terraform {
  backend "azurerm" {
    resource_group_name  = "ShopRunner_Spike"
    storage_account_name = "testpurposeofstorage"
    container_name       = "statefilecontainer"
    key                  = "terraformgithubexample.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "ShopRunner_Spike" {
  name = "ShopRunner_Spike"
}
#Create Resource Group
#resource "azurerm_resource_group" "rg1" {
#name     = "RG_Aks_cluster"
#location = "eastus2"
#}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "AKS-vnet1"
  address_space       = ["192.168.0.0/16"]
  location            = "East US"
  resource_group_name = "ShopRunner_Spike"
}

# Create Subnet for use
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = "ShopRunner_Spike"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}
resource "azurerm_kubernetes_cluster" "AKS1" {
  name                = "aks_cluster"
  location            = "East US"
  resource_group_name = "ShopRunner_Spike"
  dns_prefix          = "aks1fortest"

  default_node_pool {
    name       = "nodepool"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
