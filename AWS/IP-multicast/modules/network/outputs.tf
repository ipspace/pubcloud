# outputs of network.tf

output "vpc_id" {
    value = aws_vpc.myVPC.id
}

output "vpc_cidr" {
    value = aws_vpc.myVPC.cidr_block
}

output "subnet_id" {
    value = aws_subnet.mySubnet.id
}

output "security_group_id" {
    value = ["${aws_security_group.customSG.id}"]
}