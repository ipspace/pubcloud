# peering terraform file to establish the vpc peering connection between created VPCs

provider "aws" {
    region = var.requester_region
}

provider "aws" {
    alias = "peer"
    region = var.accepter_region
}

# create vpc peering
# Requester's side of connection

resource "aws_vpc_peering_connection" "peer" {
    peer_vpc_id = var.accepterVPC_id
    vpc_id = var.requesterVPC_id
    peer_region = var.accepter_region
    auto_accept = false

    tags = {
        Side = "Requester"
    }
}

# Accepter's side of connection

resource "aws_vpc_peering_connection_accepter" "peer" {
    provider = aws.peer
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
    auto_accept = true

    tags = {
        Side = "Accepter"
    }
}

# add peering routes to the route tables

resource "aws_route" "requester2accepter" {
    route_table_id = var.requester_RT
    destination_cidr_block = var.accepterVPC_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "accepter2requester" {
    provider = aws.peer
    route_table_id = var.accepter_RT
    destination_cidr_block = var.requesterVPC_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
