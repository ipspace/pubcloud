# main module to deploy network and webVM
locals {
  rg_location = var.regions[0]

  test_vm = flatten([
    for net_name,net_data in var.networks :
      try(net_data.vm,false) && var.deploy_vm ? [{
        name = net_name
        data = net_data
      }] : []
  ])
}

provider "azurerm" {
  features {}
}

# create resource group
resource "azurerm_resource_group" "global_rg" {
  name = var.testbed_rg_name
  location = local.rg_location
}

# create virtual networks
module "network" {
  for_each = var.networks
  source = "./vnet"
  name = each.key
  data = each.value
  rg = azurerm_resource_group.global_rg.name
  location = var.regions[each.value.region]
}

module "vm" {
  for_each = {
    for vm in local.test_vm: vm.name => vm.data
  }
  source = "./vm"
  name = format("VM_%s",each.key)
  net  = each.key
  subnet_id = module.network[each.key].subnets["${each.key}_01"].id
  rg = azurerm_resource_group.global_rg.name
  location = var.regions[each.value.region]
}

output "networks" {
  value = module.network
}

output "test_vm" {
  value = module.vm
}
