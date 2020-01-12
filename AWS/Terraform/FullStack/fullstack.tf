# full stack deploying network (vpc,...) and instance (webVM)

provider "aws" {
	region = var.region
}


###############
#create the VPC
###############

resource "aws_vpc" "My_VPC" {
	cidr_block = var.VPC_cidrblock
	enable_dns_support = var.enable_dns_support
	enable_dns_hostnames = var.enable_dns_hostnames
tags = {
	Name = "My VPC"
}

} # end of VPC resource


################
# create subnets
################

resource "aws_subnet" "public_subnet" {
	vpc_id = aws_vpc.My_VPC.id
	cidr_block = var.pub_subnetCIDR
	map_public_ip_on_launch = var.mapPublicIP
	availability_zone = var.availabilityZone

tags = {
	Name = "my public subnet"
}

} # end of public subnet resource

resource "aws_subnet" "private_subnet" {
	vpc_id = aws_vpc.My_VPC.id
	cidr_block = var.pr_subnetCIDR
	map_public_ip_on_launch = var.mapPrivateIP
	availability_zone = var.availabilityZone
	
tags = {
	Name = "my private subnet"
}

} # end of private subnet 


#########################
# create internet gateway
#########################

resource "aws_internet_gateway" "gw" {
	vpc_id = aws_vpc.My_VPC.id

tags = {
	Name = "My VPC Internet Gateway"
}

} # end of ig resource

########################
# create the route table
########################

resource "aws_route_table" "Public_RT" {
	vpc_id = aws_vpc.My_VPC.id

tags = {
	Name = "Public Route Table"
}

} # end of RT resource

####################
#create route for RT
####################

resource "aws_route" "Public_Route" {
	route_table_id = aws_route_table.Public_RT.id
	destination_cidr_block = var.destination_RT_cidr
	gateway_id = aws_internet_gateway.gw.id
	
} # end of route resource

########################################
#associating route table with the subnet
########################################

resource "aws_route_table_association" "Public_Subnet_RT_Association" {
	subnet_id = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.Public_RT.id

}

#########################
# creating security group
#########################

resource "aws_security_group" "My_VPC_SG" {
	vpc_id = aws_vpc.My_VPC.id
	name = "My VPC Security Group"
	description = "allowing ssh traffic in, http(s) out"
	
	#ingress rules
	ingress {
		cidr_blocks = var.SG_ingress_cidr
		protocol = "tcp"
		from_port = 22
		to_port = 22
	}
	egress {
		cidr_blocks = var.SG_egress_cidr
		protocol = "tcp"
		from_port = 80
		to_port = 80
	}
	egress {
		cidr_blocks = var.SG_egress_cidr
		protocol = "tcp"
		from_port = 443
		to_port = 443
	}
tags = {
	Name = "My_VPC_security_group"
	desccription = "allowing ssh traffic in, http(s) out"
}

}
#####################

#####################
# create ec2 instance
#####################

resource "aws_instance" "ubuntuVM" {
	ami = var.instance_ami
	instance_type = var.instance_type
	subnet_id = aws_subnet.public_subnet.id
	availability_zone = var.availabilityZone
	vpc_security_group_ids = [ "${aws_security_group.My_VPC_SG.id}" ]
	associate_public_ip_address = true
	key_name = var.SSH_key
	
tags = {
	Name = "Web Ubuntu Virtual Machine"
}

}