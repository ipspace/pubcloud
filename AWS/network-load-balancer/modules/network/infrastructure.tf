# infrastructure: VPC and Subnet


### Create VPC

resource "aws_vpc" "myVPC" {
    cidr_block = var.vpcCIDR
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "VPC with LB"
    }
}

### Create public subnet

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnet1CIDR
    map_public_ip_on_launch = true
    availability_zone = var.availabilityZone

    tags = {
        Name = "public subnet"
    }
}

### Create internet gateway

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "myVPC IGW" 
    }
}

### Create route table, route and association

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "myVPC RT"
    }
}

resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.rt.id
    destination_cidr_block = var.destinationCIDR
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "subnet_rt" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt.id
}

### Create security group for webserver instances

resource "aws_security_group" "webserverSG" {
    vpc_id = aws_vpc.myVPC.id
    name = "webserver security group"

    ingress {
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
    }

    ingress {
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 443
        to_port = 443
    }

    ingress {
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
    }

    ingress {
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 8
        to_port = 0
    }

    egress {
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
    }

    egress {
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 443
        to_port = 443
    }

    tags = {
        Name = "SG for webservers"
    }
}