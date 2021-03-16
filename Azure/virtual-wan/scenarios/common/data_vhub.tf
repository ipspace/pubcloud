# variables for main.tf

data "azurerm_resource_group" "vhub_rg" {
  name = var.vhub_rg_name
}

data "azurerm_virtual_wan" "wan" {
  name                = var.vwan_name
  resource_group_name = data.azurerm_resource_group.vhub_rg.name
}

data "azurerm_virtual_hub" "VH_R1" {
  name                = var.hubs[0].name
  resource_group_name = data.azurerm_resource_group.vhub_rg.name
}

data "azurerm_virtual_hub" "VH_R2" {
  name                = var.hubs[1].name
  resource_group_name = data.azurerm_resource_group.vhub_rg.name
}
