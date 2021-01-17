# variables for compute.tf

variable "instanceType" {
    type = string
    default = "t2.micro"
}

variable "subnetID" {
    description = "subnet id from infrastructure.tf"
    type = string
    default = ""
}

variable "EC2AvailabilityZone" {
    type = string
    default = "us-east-2a"
}

variable "securityGroupID" {
    description = "security group id from infrastructure.tf"
    type = list(string)
    default = null
}

variable "sshKey" {
    type = string
    default = "id_rsa_webserver"
}

variable "sshKeyLoc" {
    type = string
    default = "~/.ssh/id_rsa_webserver"
}

variable "instanceUser" {
    type = string
    default = "ubuntu"
}