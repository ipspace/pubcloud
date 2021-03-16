variable "name" {}
variable "data" {}
variable "rg" {}
variable "location" {}

locals {
  subnet_count = try(var.data.subnets,1)
  subnets = {
    for count in range(local.subnet_count) :
      format("%s_%02d",var.name,count + 1) => {
        prefix = cidrsubnet(var.data.prefix,local.subnet_count > 1 ? 8 : 2,count+1)
      }
  }
}

resource "azurerm_virtual_network" "vnet" {
  name = var.name
  location = var.location
  resource_group_name = var.rg
  address_space = [ var.data.prefix ]
}

output "network" {
  value = {
    name = var.name
    prefix = var.data.prefix
    id = azurerm_virtual_network.vnet.id
    location = var.location
  }
}

output "subnets" {
  value = azurerm_subnet.vnet_subnet
}

resource "azurerm_subnet" "vnet_subnet" {
  for_each = local.subnets
  name = each.key
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [ each.value.prefix ]
}
