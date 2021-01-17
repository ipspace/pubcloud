#!/bin/bash
#
# Create a AWS VPC, or skip the operation of the VPC already exists
#
# Read configuration variables
#
. variables.sh
set -e
set -x
#
# Create VPC
#
VPC_ID=$(aws ec2 --profile ec2 describe-vpcs \
  --filter "Name=tag:Name,Values=$VPC_NAME" --query 'Vpcs[0].VpcId' --output text)
if [ "$VPC_ID" == "None" ]; then
  echo "Creating new VPC: $VPC_NAME"
  VPC_ID=$(aws ec2 --profile ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --query 'Vpc.{VpcId:VpcId}' \
    --output text)
  echo "Created VPC $VPC_ID for CIDR block $VPC_CIDR"
  # Add Name tag to VPC
  aws ec2 create-tags --profile ec2 \
    --resources $VPC_ID \
    --tags "Key=Name,Value=$VPC_NAME"
  echo ".. $VPC_ID named $VPC_NAME"
  aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
  aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
else
  echo "VPC $VPC_NAME already exists"
fi
