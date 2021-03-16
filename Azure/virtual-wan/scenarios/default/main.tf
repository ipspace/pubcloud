# main module to deploy network and webVM
provider "azurerm" {
  features {}
}

resource "azurerm_virtual_hub_connection" "R1_Red_1" {
  name                      = "R1_Red_1"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Red_1.id
}

resource "azurerm_virtual_hub_connection" "R1_Red_2" {
  name                      = "R1_Red_2"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Red_2.id
}

resource "azurerm_virtual_hub_connection" "R2_Red_1" {
  name                      = "R2_Red_1"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Red_1.id
}

resource "azurerm_virtual_hub_connection" "R2_Red_2" {
  name                      = "R2_Red_2"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R2.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Red_2.id
}

resource "azurerm_virtual_hub_connection" "R1_Blue" {
  name                      = "R1_Blue"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R1.id
  remote_virtual_network_id = data.azurerm_virtual_network.R1_Blue.id
}

resource "azurerm_virtual_hub_connection" "R2_Blue" {
  name                      = "R2_Blue"
  virtual_hub_id            = data.azurerm_virtual_hub.VH_R2.id
  remote_virtual_network_id = data.azurerm_virtual_network.R2_Blue.id
}
