# main file to deploy network infrastructure - vpc, two subnets, ig, route table

# get availability zones
data "aws_availability_zones" "available" {
	state = "available"
}

# VPC

resource "aws_vpc" "wafVPC" {
	cidr_block = var.vpc_cidr
	enable_dns_support = true
	enable_dns_hostnames = true

tags = {
	Name = "VPC-1"
	}
}

# Subnets (2 public, 1 private)

resource "aws_subnet" "publicSub1" {
	vpc_id = aws_vpc.wafVPC.id
	cidr_block = var.pub1_cidr
	map_public_ip_on_launch = true
	availability_zone = data.aws_availability_zones.available.names[0]

tags = {
	Name = "Public-Subnet-1"
	}
} 

resource "aws_subnet" "publicSub2" {
	vpc_id = aws_vpc.wafVPC.id
	cidr_block = var.pub2_cidr
	map_public_ip_on_launch = true
	availability_zone = data.aws_availability_zones.available.names[1]
	
tags = {
	Name = "Public-Subnet-2"
	}
} 

resource "aws_subnet" "privateSub1" {
	vpc_id = aws_vpc.wafVPC.id
	cidr_block = var.prvt1_cidr
	map_public_ip_on_launch = false
	availability_zone = data.aws_availability_zones.available.names[0]
	
tags = {
	Name = "Private-Subnet-1"
	}
} 

# internet gateway

resource "aws_internet_gateway" "gw" {
	vpc_id = aws_vpc.wafVPC.id

tags = {
	Name = "VPC-1-GW"
	}
}

# Route Table

resource "aws_route_table" "publicRT" {
	vpc_id = aws_vpc.wafVPC.id
tags = {
	Name = "Public-RT"
}
}

resource "aws_route" "publicRoute" {
	route_table_id = aws_route_table.publicRT.id 
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public1RT" {
	route_table_id = aws_route_table.publicRT.id
	subnet_id = aws_subnet.publicSub1.id
}

resource "aws_route_table_association" "public2RT" {
	route_table_id = aws_route_table.publicRT.id
	subnet_id = aws_subnet.publicSub2.id
}

# create webserver security group

resource "aws_security_group" "webserverSG" {
	vpc_id = aws_vpc.wafVPC.id
	name = "Webserver SG"

	ingress {
		description = "allow SSH from jump host"
		protocol = "tcp"
		from_port = 22
		to_port = 22
		security_groups = [aws_security_group.bastionSG.id]
	}

	ingress {
		description = "allow HTTP"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		to_port = 80
	}

	ingress {
		description = "allow HTTPS"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]  
		from_port = 443
		to_port = 443
	}

	ingress {
		description = "allow ping"
		protocol = "icmp"
		from_port = 8
		to_port = 0
		security_groups = [aws_security_group.bastionSG.id]
	}

	egress {
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		to_port = 0
	}

	tags = {
		Name = "Webserver security group"
	}
}

# create jump host/bastion security group

resource "aws_security_group" "bastionSG" {
	vpc_id = aws_vpc.wafVPC.id
	name = "Bastion SG"

	ingress {
		description = "allow SSH"
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"] #ideally your public ip *.*.*.*/32
		from_port = 22
		to_port = 22
	}

	egress {
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		to_port = 0
	}
	tags = {
		Name = "Bastion host security group"
	}
}

# create private instance / Database security group

resource "aws_security_group" "databaseSG" {
	vpc_id = aws_vpc.wafVPC.id
	name = "Database SG"

	ingress {
		description = "allow HTTP"
		protocol = "tcp"
		from_port = 80
		to_port = 80
		self = true
		security_groups = [aws_security_group.webserverSG.id]
	}

	ingress {
		description = "allow MySQL"
		protocol = "tcp"
		from_port = 3306
		to_port = 3306
		self = true
		security_groups = [aws_security_group.webserverSG.id]
	}

	ingress {
		description = "allow SSH from bastion host"
		protocol = "tcp"
		from_port = 22
		to_port = 22
		security_groups = [aws_security_group.bastionSG.id]
	}

	egress {
		protocol = "-1"
		from_port = 0
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "Database security group"
	}
}

resource "aws_security_group" "albSG" {
	vpc_id = aws_vpc.wafVPC.id
	name = "Application-LB SG"

	ingress {
		description = "allow web HTTP"
		protocol = "tcp"
		from_port = 80
		to_port = 80
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "allow web HTTPS"
		protocol = "tcp"
		from_port = 443
		to_port = 443
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description = "allow ping"
		protocol = "icmp"
		from_port = 8
		to_port = 0
		security_groups = [aws_security_group.bastionSG.id]
	}

	egress {
		description = "allow all outbound"
		protocol = "-1"
		from_port = 0
		to_port = 0
		cidr_blocks = ["0.0.0.0/0"]
	}
}