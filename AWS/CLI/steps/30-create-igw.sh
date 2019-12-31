#!/bin/bash
#
# Create Internet Gateway and attach it to already-created VPC
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
# Find or create Internet gateway
#
IGW_ID=$(aws ec2 --profile ec2 describe-internet-gateways \
  --filter "Name=tag:Name,Values=$VPC_NAME-igw" \
  --query 'InternetGateways[0].InternetGatewayId' --output text)
if [ "$IGW_ID" == "None" ]; then
  echo "Creating Internet Gateway..."
  IGW_ID=$(aws ec2 create-internet-gateway --profile ec2 \
    --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
    --output text )
  echo ".. Internet Gateway $IGW_ID created"
  # Add Name tag to IGW
  aws ec2 create-tags --profile ec2 \
    --resources $IGW_ID \
    --tags "Key=Name,Value=$VPC_NAME-igw"
  echo ".. $IGW_ID named $VPC_NAME-igw"
else
  echo "INFO: Internet gateway $VPC_NAME-igw already exists: $IGW_ID"
fi
#
# Attach Internet gateway to VPC
#
ATT_GW=$(aws ec2 --profile ec2 describe-internet-gateways \
  --internet-gateway-ids $IGW_ID \
  --query "InternetGateways[0].Attachments[0].VpcId" \
  --output text)
if [ "$ATT_GW" == "None" ]; then
  aws ec2 attach-internet-gateway --profile ec2 \
    --vpc-id $VPC_ID \
    --internet-gateway-id $IGW_ID
  echo "Internet Gateway ID $IGW_ID attached to VPC $VPC_ID"
elif [ $ATT_GW == $VPC_ID ]; then
  echo "Internet gateway already attached to VPC"
else
  echo "ERROR: Internet gateway $IGW_ID attached to unknown VPC $VPC_ID"
  exit
fi
