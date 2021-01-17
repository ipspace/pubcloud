# main terraform module to deploy VPC, Subnet, instances and load balancer

provider "aws" {
    region = "us-east-2"
}

module "infrastructure" {
    source = "./modules/network"
}

module "compute" {
    source = "./modules/compute"

    subnetID = module.infrastructure.subnetID
    securityGroupID = module.infrastructure.webserverSgID
}

module "loadbalancing" {
    source = "./modules/lb"

    vpcID = module.infrastructure.vpcID
    subnetID = module.infrastructure.subnetID
    web1ID = module.compute.web1ID
    web2ID = module.compute.web2ID
    web3ID = module.compute.web3ID
}

output "webserver1_public_ip" {
    value = module.compute.web1IP
}

output "webserver2_public_ip" {
    value  = module.compute.web2IP
}

output "webserver3_public_ip" {
    value= module.compute.web3IP
}

output "LoadBalancer_public_ip" {
    value = module.loadbalancing.lbIP
}
