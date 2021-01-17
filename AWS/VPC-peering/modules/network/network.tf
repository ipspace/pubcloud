# network terraform file to deploy VPC and 2 subnets

provider "aws" {
    region = var.region
}

# Create VPC

resource "aws_vpc" "myVPC" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = var.vpc_name
    } 
}

# Create subnets

resource "aws_subnet" "subnetA" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnetA_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}a"

    tags = {
        Name = var.subnetA_name
    } 
}

resource "aws_subnet" "subnetB" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = var.subnetB_cidr
    map_public_ip_on_launch = true 
    availability_zone = "${var.region}b"

    tags = {
        Name = var.subnetB_name
    } 
}

# Create internet gateway

resource "aws_internet_gateway" "myGW" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "${var.vpc_name}-GW" 
    }
}

# Create route table, route and association

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.myVPC.id

    tags = {
        Name = "${var.vpc_name}-RT"
    }
}

resource "aws_route" "publicRoute" {
    route_table_id = aws_route_table.myRT.id
    destination_cidr_block = var.destination_cidr
    gateway_id = aws_internet_gateway.myGW.id
}

resource "aws_route_table_association" "subARoute" {
    subnet_id = aws_subnet.subnetA.id
    route_table_id = aws_route_table.myRT.id
}

resource "aws_route_table_association" "subBRoute" {
    subnet_id = aws_subnet.subnetB.id
    route_table_id = aws_route_table.myRT.id
}

# Create security group

resource "aws_security_group" "instanceSG" {
    description = "Basic security group for instances in ${var.vpc_name}"
    vpc_id = aws_vpc.myVPC.id

    ingress {
        description = "allow SSH"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # ideally your public IP range!!
        from_port = 22
        to_port = 22
    }

    ingress {
        description = "allow HTTP from requester and accepter VPCs"
        protocol = "tcp"
        cidr_blocks = [aws_vpc.myVPC.cidr_block, var.otherVPC_cidr]
        from_port = 80
        to_port = 80
    }

    egress {
        description = "allow all outbound traffic"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 0
        to_port = 0
    }
}