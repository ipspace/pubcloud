# file to create transit gateway

# create transit gateway 

#resource "aws_ec2_transit_gateway" "tgw" {
#    auto_accept_shared_attachments = "enable" 
#    default_route_table_association = "enable"
#    default_route_table_propagation = "enable"
#    dns_support = "enable"
#
#    tags = {
#        Name = "multicast-tg"
#    }
#}

# gather info on transit gateway created through AWS CLI

data "aws_ec2_transit_gateway" "tgw" {
    filter {
        name = "options.amazon-side-asn"
        values = ["64512"] #this is actually the default asn 
    }

    filter {
        name = "state"
        values = ["available", "pending"] 
    }

    filter {
        name = "tag:Name"
        values = ["Multicast-TG"] 
    }
}

#create vpc attachments to tgw

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcAtgw" {
  subnet_ids = ["${var.vpc_a_subnet1_id}"]
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_a_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpcBtgw" {
  subnet_ids = ["${var.vpc_b_subnet1_id}"]
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id = var.vpc_b_id
}


#output transit gateway id

output "tg_id" {
    value = data.aws_ec2_transit_gateway.tgw.id
}

output "tg_vpc_a_attachment" {
    value = aws_ec2_transit_gateway_vpc_attachment.vpcAtgw.id
}

output "tg_vpc_b_attachment" {
    value = aws_ec2_transit_gateway_vpc_attachment.vpcBtgw.id
}
