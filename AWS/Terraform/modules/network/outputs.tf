#outputs of network.tf resources for use in other modules

output "subnet_id" {
	value = aws_subnet.public_subnet.id
	description = "id of public subnet"
}

output "security_group_id" {
	value = [ "${aws_security_group.My_VPC_SG.id}" ]
	description = "id of security group for ec2 instance"
}

