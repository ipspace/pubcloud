# outputs for infrastructure.tf

output "vpcID" {
    value = aws_vpc.myVPC.id
    description = "id of created vpc"
}

output "subnetID" {
    value = aws_subnet.subnet1.id
    description = "id of created pub subnet"
}

output "subnetIDlist" {
    value = [ "${aws_subnet.subnet1.id}" ]
    description = "list of subnet IDs for lb"
}

output "webserverSgID" {
    value = [ "${aws_security_group.webserverSG.id}" ]
    description = "id of webserver security group"
}