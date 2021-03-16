# main module to deploy network and webVM
locals {
  rg_location = var.hubs[0].region
  hub_map =  {
    for hub in var.hubs:
      hub.name => {
        region = hub.region
        prefix = hub.prefix
      }
  }
}

provider "azurerm" {
  features {}
}

# create resource group
#
resource "azurerm_resource_group" "vhub_rg" {
  name = var.vhub_rg_name
  location = local.rg_location
}

# create virtual WAN
#
resource "azurerm_virtual_wan" "wan" {
  name                = var.vwan_name
  resource_group_name = azurerm_resource_group.vhub_rg.name
  location            = local.rg_location
}

# create virtual hubs in all regions
#
resource "azurerm_virtual_hub" "vhub" {
  for_each = local.hub_map
  name                = each.key
  resource_group_name = azurerm_resource_group.vhub_rg.name
  location            = each.value.region
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = each.value.prefix
}
