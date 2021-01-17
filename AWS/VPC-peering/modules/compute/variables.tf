# variables for compute.tf

variable "region" {
    description = "selected region"
    type = string
    default = ""
}

variable "instance_type" {
    description = "selected instance type"
    type = string
    default = "t2.micro"
} 

variable "subnetA_id" {
    description = "imported ID of subnet A from network.tf"
    type = string
    default = ""
}

variable "subnetB_id" {
    description = "imported ID of subnet B from network.tf"
    type = string
    default = ""
}

variable "security_id" {
    description = "ID of security group from network.tf"
    type = list(string)
    default = null
}

variable "ssh_key" {
    description = "ssh key used to connect to the instances"
    type = string
    default = "id_rsa_webserver"
}

variable "key_loc" {
    description = "ssh key location"
    type = string
    default = "~/.ssh/id_rsa_webserver"
}