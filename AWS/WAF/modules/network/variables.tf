# variables for network.tf

variable "vpc_cidr" {
    type =  string
    default = "172.19.0.0/16"
}

variable "pub1_cidr" {
    type = string
    default = "172.19.1.0/24"
}

variable "pub2_cidr" {
    type = string
    default = "172.19.2.0/24"
} 

variable "prvt1_cidr" {
    type = string
    default = "172.19.3.0/24"
}
