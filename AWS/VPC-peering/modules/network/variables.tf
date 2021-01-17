# variables for network.tf

variable "region" {
    description = "selected region"
    type = string
    default = ""
}

variable "vpc_cidr" {
    description = "vpc CIDR block"
    type = string
    default = ""
}

variable "vpc_name" {
    description = "vpc name"
    type = string
    default = ""
}

variable "subnetA_cidr" {
    description = "cidr block for subnet A"
    type = string
    default = ""
}

variable "subnetA_name" {
    description = "subnet A name"
    type = string
    default = ""
}

variable "subnetB_cidr" {
    description = "cidr block for subnet B"
    type = string
    default = ""
}

variable "subnetB_name" {
    description = "subnet B name"
    type = string
    default = ""
}

variable "destination_cidr" {
    description = "Route destination cidr"
    type = string
    default = "0.0.0.0/0"
}

variable "otherVPC_cidr" {
    description = "cidr block of the VPC created in other region"
    type = string
    default = ""
}