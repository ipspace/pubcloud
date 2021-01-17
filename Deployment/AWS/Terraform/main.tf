# calling module for deploying network and ec2 instance

provider "aws" {
	region = var.region
}

module "network" {
	source = "./modules/network"
}

module "ec2instance" {
	source = "./modules/compute"
	
	vpc_subnet_id = module.network.subnet_id
	ec2_security_group_id = module.network.security_group_id
}