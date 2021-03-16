# variables for main.tf

data "azurerm_resource_group" "testbed_rg" {
  name = var.testbed_rg_name
}

data "azurerm_virtual_network" "R1_Red_1" {
  name = "R1_T1_1"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}

data "azurerm_virtual_network" "R1_Red_2" {
  name = "R1_T1_2"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}

data "azurerm_virtual_network" "R2_Red_1" {
  name = "R2_T1_1"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}

data "azurerm_virtual_network" "R2_Red_2" {
  name = "R2_T1_2"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}

data "azurerm_virtual_network" "R1_Blue" {
  name = "R1_T2"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}

data "azurerm_virtual_network" "R2_Blue" {
  name = "R2_T2"
  resource_group_name = data.azurerm_resource_group.testbed_rg.name
}
