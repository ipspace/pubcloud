#!/bin/bash
#
VPC_CIDR=172.19.0.0/17
VPC_NAME="test_vpc"
SUBNET_CIDR=172.19.1.0/24
SUBNET_NAME="public"
SG_NAME="web-sg"
SG_DESC="Web server security group"
WEB_PORTS="80 443"
INET_PORTS="22 $WEB_PORTS"
