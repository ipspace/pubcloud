# outputs of variables.tf

output "subnetA_id" {
    description = "subnet A ID"
    value = aws_subnet.subnetA.id
}

output "subnetB_id" {
    description = "subnet B ID"
    value = aws_subnet.subnetB.id
}

output "security_id" {
    description = "security group ID"
    value = ["${aws_security_group.instanceSG.id}"]
}

output "vpc_cidr" {
    description = "this VPC cidr block to include it in the security group rules"
    value = aws_vpc.myVPC.cidr_block
}

output "vpc_id" {
    description = "created VPC ID"
    value = aws_vpc.myVPC.id
}

output "route_table_id" {
    description = "route table ID output for peering"
    value = aws_route_table.myRT.id
}