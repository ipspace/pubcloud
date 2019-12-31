#!/bin/bash
#
# Create a subnet with an already-created VPC or fail if the VPC doesn't exist yet
#
# Read configuration variables
#
. variables.sh
set -e
#
# Find VPC
#
VPC_ID=$(aws ec2 --profile ec2 describe-vpcs \
  --filter "Name=tag:Name,Values=$VPC_NAME" --query 'Vpcs[0].VpcId' --output text)
if [ "$VPC_ID" == "None" ]; then
  echo "ERROR: Cannot find VPC $VPC_NAME"
  exit 1
fi
#
# Create subnet
#
SUBNET_ID=$(aws ec2 --profile ec2 describe-subnets \
  --filter "Name=tag:Name,Values=$SUBNET_NAME" --query 'Subnets[0].SubnetId' --output text)
if [ "$SUBNET_ID" == "None" ]; then
  echo "Creating new subnet: $SUBNET_NAME"
  SUBNET_ID=$(aws ec2 --profile ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $SUBNET_CIDR \
    --query 'Subnet.{SubnetId:SubnetId}' \
    --output text )
  echo "Created subnet $SUBNET_ID for CIDR block $SUBNET_CIDR"
  # Add Name tag to subnet
  aws ec2 create-tags --profile ec2 \
    --resources $SUBNET_ID \
    --tags "Key=Name,Value=$SUBNET_NAME"
  echo ".. $SUBNET_ID named $SUBNET_NAME"
else
  echo "Subnet $SUBNET_NAME $SUBNET_ID already exists"
fi
