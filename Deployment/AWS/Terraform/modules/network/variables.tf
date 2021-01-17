# variables.tf for network.tf


variable "availabilityZone" {
	description = "picking the right availability zone in your region"
	default = "us-east-2a"
}

variable "VPC_cidrblock" {
	default = "10.0.0.0/16"
}

variable "enable_dns_support" {
	type = bool
	default = true
}

variable "enable_dns_hostnames" {
	type = bool
	default = true
}

variable "pub_subnetCIDR" {
	default = "10.0.10.0/24"
}

variable "pr_subnetCIDR" {
	default = "10.0.20.0/24"
}

variable "mapPublicIP" {
	default = true
}

variable "mapPrivateIP" {
	default = false
}

variable "destination_RT_cidr" {
	default = "0.0.0.0/0"
}

variable "SG_ingress_cidr" {
	type = list
	default = [ "0.0.0.0/0" ]
}

variable "SG_egress_cidr" {
	type = list
	default = [ "0.0.0.0/0" ]
}

# end of variables