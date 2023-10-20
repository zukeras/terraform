locals {
  virtula_network_subnets = {
    name          = ["SubnetA", "SubnetB"]
    address_space = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}
resource "azurerm_resource_group" "appgrp" {
  name     = var.rg_name
  location = var.location
}
resource "azurerm_storage_account" "appstoragezukeras" {
  name                     = "appstoragezukeras"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.appstoragezukeras.name
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "upload_script_for_VM" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.appstoragezukeras.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "main.tf"
}
resource "azurerm_virtual_network" "Linux_VN" {
  name                = "Linux_VN"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = [var.VN_address_space]

  subnet {
    name           = var.Subnets_names[0]
    address_prefix = var.Subnets_addresses[0]
  }

  subnet {
    name           = var.Subnets_names[1]
    address_prefix = var.Subnets_addresses[1]
  }

}

resource "azurerm_public_ip" "vm_ip" {
  name                = "Public_IP"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "Linux_NIC" {
  name                = "Linux_NIC"
  resource_group_name = var.rg_name
  location            = var.location

  ip_configuration {
    name                          = "Internal IP"
    subnet_id                     = tolist(azurerm_virtual_network.Linux_VN.subnet)[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }

}

output "subnet-name" {
value = tolist(azurerm_virtual_network.Linux_VN.subnet)[0].id
}


