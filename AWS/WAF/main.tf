# main terraform module to deploy AWS bastion host infrastructure demo

variable "region" {
	description = "select the region of deployment"
	default = "eu-west-2"
}

provider "aws" {
    region = var.region
	version = "~> 2.68.0"
}

module "network" {
    source = "./modules/network"

}

module "instances" {
	source = "./modules/compute"
	
	pub_sub1_id = module.network.pub_sub1_id
	pub_sub2_id = module.network.pub_sub2_id
	prvt_sub1_id = module.network.prvt_sub1_id
	webserver_sg_id = module.network.webserver_sg_id
	bastion_sg_id = module.network.bastion_sg_id
	database_sg_id = module.network.database_sg_id
}

module "loadbalancer" {
	source = "./modules/balancer"

	alb_security_group_id = module.network.alb_sg_id
	pub_sub1_id = module.network.pub_sub1_id
	pub_sub2_id = module.network.pub_sub2_id
	vpc_id =  module.network.vpc_id
	web1_id = module.instances.web1_id
	web2_id = module.instances.web2_id
}

module "waf" {
	source = "./modules/waf"

	alb_arn = module.loadbalancer.alb_arn
}

output "webserver1_public_ip" {
	value = module.instances.web1_pub_ip
}

output "webserver1_private_ip" {
	value = module.instances.web1_prvt_ip
}

output "webserver2_public_ip" {
	value = module.instances.web2_pub_ip
}

output "webserver2_private_ip" {
	value = module.instances.web2_prvt_ip
}

output "jumphost_public_ip" {
	value = module.instances.bastion_pub_ip
}

output "database_private_ip" {
	value = module.instances.database_prvt_ip
}

output "alb_dns_name" {
	value = module.loadbalancer.alb_dns_name
}