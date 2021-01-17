#outputs of network.tf resources for use in other modules

output "vpc_id" {
	value = aws_vpc.wafVPC.id
}

output "pub_sub1_id" {
	value = aws_subnet.publicSub1.id
	description = "id of public subnet 1"
}

output "pub_sub2_id" {
	value = aws_subnet.publicSub2.id
	description = "id of public subnet 2"
}

output "prvt_sub1_id" {
	value = aws_subnet.privateSub1.id
	description = "id of private subnet 1"
}

output "webserver_sg_id" {
	value = [ "${aws_security_group.webserverSG.id}" ]
	description = "id of a webserver security group for ec2 instances"
}

output "bastion_sg_id" {
	value = [ "${aws_security_group.bastionSG.id}" ]
	description = "id of a bastion security group for ec2 instance"
}

output "database_sg_id" {
	value = [ "${aws_security_group.databaseSG.id}" ]
	description = "id of a database security group"
}

output "alb_sg_id" {
	value = ["${aws_security_group.albSG.id}"]
	description = "id of application load balancer security group"
}
