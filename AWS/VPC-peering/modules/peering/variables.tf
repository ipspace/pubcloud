# variables for peering.tf

variable "requester_region" {
    description = "region in which the requester VPC is created"
    type = string
    default = ""
}

variable "accepter_region" {
    description = "region in which the accepter VPC is created"
    type = string
    default = ""
}

variable "requesterVPC_id" {
    description = "Requester VPC ID"
    type = string
    default = ""
}

variable "accepterVPC_id" {
    description = "Accepter VPC ID"
    type = string
    default = ""
}

variable "requesterVPC_cidr" {
    description = "Requester VPC CIDR"
    type = string
    default = ""
}

variable "accepterVPC_cidr" {
    description = "Accepter VPC CIDR"
    type = string
    default = ""
}

variable "requester_RT" {
    description = "requester vpc route table id"
    type = string
    default = ""
}

variable "accepter_RT" {
    description = "accepter vpc route table id"
    type = string
    default = ""
}