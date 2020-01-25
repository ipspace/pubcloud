# main module to deploy network and webVM

provider "azurerm" {
}

module "network" {
	source = "./modules/network"
}

module "WebVM" {
	source = "./modules/compute"

	rg_name = module.network.resourcegroup
	nic_id = module.network.nicID
}
