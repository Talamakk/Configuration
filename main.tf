terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  required_version = ">= 1.5.0" 
}

provider "azurerm" {
  # Configuration options
  features {}
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = join("-", ["rg", var.project_name, var.env])
  location = var.region
}

resource "azurerm_virtual_network" "vnet" {
  name                = join("-", ["vnet", var.project_name])
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet0" {
  name                 = "app_gw_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.255.224/27"]
  # maska podsieci 27: 32 adresów dostępnych, ale 5 zabiera Azure (4 pierwsze i 1 ostatni), więc mamy dostępne: 10.0.255.228 - 10.0.255.254
}

resource "azurerm_subnet" "subnet1" {
  name                 = "web_tier_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "logic_tier_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "data_tier_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_key_vault" "kv" {
  name                      = join("-", ["kv", var.project_name])
  location                  = var.region
  resource_group_name       = azurerm_resource_group.rg.name
  sku_name                  = "standard"
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
}

resource "azurerm_container_registry" "acr" {
  name                = join("", ["acr", var.project_name])
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  sku                 = "Basic"
}