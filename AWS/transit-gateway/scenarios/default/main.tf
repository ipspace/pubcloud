# main module to deploy network and webVM
provider "aws" {
  region = var.regions[0]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "N1" {
  tags = {
    Name = "N1_attach"
  }
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = data.aws_vpc.N1.id
  subnet_ids         = [ data.aws_subnet.N1_tgw.id ]
}

resource "aws_route" "N1_N2" {
  route_table_id = data.aws_vpc.N1.main_route_table_id
  destination_cidr_block = data.aws_vpc.N2.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "N1_N3" {
  route_table_id = data.aws_vpc.N1.main_route_table_id
  destination_cidr_block = data.aws_vpc.N3.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "N2" {
  tags = {
    Name = "N2_attach"
  }
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = data.aws_vpc.N2.id
  subnet_ids         = [ data.aws_subnet.N2_tgw.id ]
}

resource "aws_route" "N2_N1" {
  route_table_id = data.aws_vpc.N2.main_route_table_id
  destination_cidr_block = data.aws_vpc.N1.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "N2_N3" {
  route_table_id = data.aws_vpc.N2.main_route_table_id
  destination_cidr_block = data.aws_vpc.N3.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "N3" {
  tags = {
    Name = "N3_attach"
  }
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = data.aws_vpc.N3.id
  subnet_ids         = [ data.aws_subnet.N3_tgw.id ]
}

resource "aws_route" "N3_N1" {
  route_table_id = data.aws_vpc.N3.main_route_table_id
  destination_cidr_block = data.aws_vpc.N1.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "N3_N2" {
  route_table_id = data.aws_vpc.N3.main_route_table_id
  destination_cidr_block = data.aws_vpc.N2.cidr_block
  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
}
