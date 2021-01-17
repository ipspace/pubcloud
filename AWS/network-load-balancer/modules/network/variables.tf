# variables for infrastructure.tf

variable "vpcCIDR" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet1CIDR" {
    type = string
    default = "10.0.1.0/24"
}

variable "availabilityZone" {
    type = string
    default = "us-east-2a"
}

variable "destinationCIDR" {
    type = string
    default = "0.0.0.0/0"
}