# variables for compute.tf

variable "region" {
    type = string
    default = "eu-west-2"
}

variable "instance_type" {
    description = "defined type of EC2 instance"
    type = string
    default = "t2.micro"
}

variable "subnet_id" {
    description = "the ID of a subnet in which the instance should be deployed"
    type = string
    default = ""
}

variable "security_group_id" {
    description = "a list of security group IDs, to attach to this instance"
    type = list(string)
    default = null
}

variable "ssh_key" {
    description = "ssh key used to connect to the instance" 
    type = string
    default = "id_rsa_webserver" 
}

variable "key_loc" {
    description = "ssh_key location" 
    type = string
    default = "~/.ssh/id_rsa_webserver" 
}

variable "instance_name_tag" {
    type = string
    default = ""
}

variable "instance_role_tag" {
    type = string
    default = ""
}