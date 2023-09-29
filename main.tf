terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.8.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "95aeef37-ead5-454b-bced-99ef36960eee"
  client_id       = "831347a4-4926-4fa4-8b13-f3c8c52d61a2"
  tenant_id       = "ac18975c-2f35-480e-97f9-ad7e89601468"
  client_secret   = "66Z8Q~deWR4otj.QsjThjvLNmLj6ISFAkuCZdbLX"
  features {}
}
resource "azurerm_resource_group" "appgrp" {
  name     = var.rg_name
  location = "North Europe"
}
resource "azurerm_storage_account" "appstoragezukeras" {
  name                     = "appstoragezukeras"
  resource_group_name      = var.rg_name
  location                 = azurerm_resource_group.appgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.appstoragezukeras.name
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "upload" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.appstoragezukeras.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "main.tf"
}

