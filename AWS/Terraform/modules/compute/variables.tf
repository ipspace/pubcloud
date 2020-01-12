# variables.tf for compute.tf


variable "instance_ami" {
	description = "Ubuntu Server 18.04 LTS (64-bit x86)"
	default = "ami-0d5d9d301c853a04a"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "ec2_AZ" {
	default = "us-east-2a"
}

variable "vpc_subnet_id" {
	description = "ID of public subnet where EC2 should be deployed"
	type = string
	default = ""
}

variable "ec2_security_group_id" {
	description = "ID of security group to be attached to ec2 instance"
	type = list(string)
	default = null
}

variable "SSH_key" {
	type = string
	default = "ec2_key"
}