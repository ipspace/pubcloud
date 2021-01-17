# main terraform file to deploy VPCs, subnets, instances and transit gateway serving as a multicast router 
# enabling multicast communication between instances

variable "region" {
    type = string
    default = "eu-west-2"
}

# define the provider

provider "aws" {
    region = var.region
}

# modules to execute

module "vpc_a" {
    source = "./modules/network"
    
    vpc_cidr = "10.0.0.0/16"
    vpc_name_tag = "VPC-A"
    subnet_cidr = "10.0.1.0/24"
    subnet_name_tag = "subnet1"
    transit_gateway_id = module.transit.tg_id
}

module "vpc_b" {
    source = "./modules/network"
    
    vpc_cidr = "10.10.0.0/16"
    vpc_name_tag = "VPC-B"
    subnet_cidr = "10.10.1.0/24"
    subnet_name_tag = "subnet1"
    transit_gateway_id = module.transit.tg_id
}

module "transit" {
    source = "./modules/transit"

    vpc_a_id = module.vpc_a.vpc_id
    vpc_a_cidr = module.vpc_a.vpc_cidr
    vpc_a_subnet1_id = module.vpc_a.subnet_id
    vpc_b_id = module.vpc_b.vpc_id
    vpc_b_cidr = module.vpc_b.vpc_cidr
    vpc_b_subnet1_id = module.vpc_b.subnet_id
}

module "compute_a" {
    source = "./modules/compute"

    subnet_id = module.vpc_a.subnet_id
    security_group_id = module.vpc_a.security_group_id
    instance_type = "t3a.nano"
    instance_name_tag = "webserver_1(VPC-A)"
    instance_role_tag = "multicast_source"
}

module "compute_b1" {
    source = "./modules/compute"

    subnet_id = module.vpc_b.subnet_id
    security_group_id = module.vpc_b.security_group_id
    instance_name_tag = "webserver_1(VPC-B)"
    instance_role_tag = "multicast_receiver"
}

module "compute_b2" {
    source = "./modules/compute"

    subnet_id = module.vpc_b.subnet_id
    security_group_id = module.vpc_b.security_group_id
    instance_name_tag = "webserver_2(VPC-B)"
    instance_role_tag = "multicast_receiver"
}

# outputs needed for transit gateway multicast setup:

output "transit_gateway_id" {
    value = module.transit.tg_id
}

output "tg_vpc_a_attachment_id" {
    value = module.transit.tg_vpc_a_attachment
}

output "vpc_a_subnet_id" {
    value = module.vpc_a.subnet_id
}

output "tg_vpc_b_attachment_id" {
    value = module.transit.tg_vpc_b_attachment
}

output "vpc_b_subnet_id" {
    value = module.vpc_b.subnet_id
}

output "vpc_a_instance1_NIC_id" {
    value = module.compute_a.instance_nic_id
}

output "vpc_b_instance1_NIC_id" {
    value = module.compute_b1.instance_nic_id
}

output "vpc_b_instance2_NIC_id" {
    value = module.compute_b2.instance_nic_id
}
