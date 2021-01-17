# variables for compute.tf

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "pub_sub1_id" {
    description = "public subnet 1 ID from network.tf"
    type = string
    default = ""
}

variable "pub_sub2_id" {
    description = "public subnet 2 ID from network.tf"
    type = string
    default = ""
}

variable "prvt_sub1_id" {
    description = "private subnet 1 ID from network.tf"
    type = string
    default = ""
}

variable "webserver_sg_id" {
    description = "webserver security group id form network.tf"
    type = list(string)
    default = null
}

variable "bastion_sg_id" {
    description = "jump host / bastion security group id form network.tf"
    type = list(string)
    default = null
}

variable "database_sg_id" {
    description = "private security group id form network.tf"
    type = list(string)
    default = null
}

variable "ssh_key" {
    type = string
    default = "id_rsa_webserver"
}

variable "key_loc" {
    type = string
    default = "~/.ssh/id_rsa_webserver"
}

variable "instance_user" {
    type = string
    default = "ubuntu"
}