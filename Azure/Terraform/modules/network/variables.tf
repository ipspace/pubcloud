# variables for network.tf

variable "location" {
	description = "Azure location"
	type = string
	default = null
}

variable "rg_name" {
	type = string
	default = null
}

variable "network_name" {
	type = string
	default = "VNet"
}

variable "network_ip" {
	type = list(string)
	default = ["172.19.0.0/17"]
}

variable "public_sub_name" {
	type = string
	default = "Public"
}

variable "public_sub_address" {
	type = string
	default = "172.19.1.0/24"
}

variable "private_sub_name" {
	type = string
	default = "Private"
}

variable "private_sub_address" {
	type = string
	default = "172.19.2.0/24"
}

variable "rt_name" {
	type = string
	default = "Private_RT"
}

variable "route_name" {
	type = string
	default = "drop_Int_access"
}

variable "pub_ip_name" {
	type = string
	default = "VM_Public_IP"
}

variable "pub_ip_method" {
	type = string
	default = "Static"
}

variable "sg_name" {
	type = string
	default = "Public_SG"
}

variable "nic_name" {
	type = string
	default = "VM_NIC"
}

variable "nic_ip_conf_name" {
	type = string
	default = "VM_NIC_Config"
}