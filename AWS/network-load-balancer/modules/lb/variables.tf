# variables for load balancer - nlb.tf file

variable "lbName" {
    description = "name of the load balancer"
    default = "subnet1-lb"
}

variable "lbType" {
    description = "choose between network or application load balancer"
    default = "network"
}

variable "vpcID" {
    description = "vpc id from infrastructure"
    type = string
    default = ""
}

variable "subnetID" {
    description = "subnet ID to be added to load balancer"
    type = string
    default = ""
}

variable "tgNameHttp" {
    type = string
    default = "example-lb-tg-http"
}

variable "tgNameHttps" {
    type = string
    default = "example-lb-tg-https"
}

variable "tgType" {
    type = string
    default = "instance"
}

variable "web1ID" {
    type = string
    default = ""
}

variable "web2ID" {
    type = string
    default = ""
}

variable "web3ID" {
    type = string
    default = ""
}