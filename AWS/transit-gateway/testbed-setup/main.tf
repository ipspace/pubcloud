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

provider "aws" {
  region = local.rg_location
}

resource "aws_key_pair" "tgw-lab" {
  key_name = "tgw-lab"
  public_key = file("~/.ssh/id_rsa.pub")
}

# create virtual networks
module "network" {
  for_each = var.networks
  source = "./vpc"
  name = each.key
  data = each.value
}

module "vm" {
  for_each = {
    for vm in local.test_vm: vm.name => vm.data
  }
  source = "./vm"
  name = format("VM_%s",each.key)
  ssh_key = "tgw-lab"
  subnet_id = module.network[each.key].subnets["${each.key}_01"].id
}

resource "aws_ec2_transit_gateway" "tgw" {
  description = "TGW"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = {
    Name = "tgw"
  }
}

output "networks" {
  value = module.network
}

output "test_vm" {
  value = module.vm
}

output "tgw" {
  value = {
    id = aws_ec2_transit_gateway.tgw.id
    arn = aws_ec2_transit_gateway.tgw.arn
  }
}
