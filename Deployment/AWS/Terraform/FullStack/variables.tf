# variables for fullstack.tf

variable "region" {
	type = string
	default = "us-east-2"
}

###################
# network variables
###################

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

############################
# compute variables
############################

variable "instance_ami" {
	description = "Ubuntu Server 18.04 LTS (64-bit x86)"
	default = "ami-0d5d9d301c853a04a"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "SSH_key" {
	type = string
	default = "ec2_key"
}