#!/bin/bash
#
STACK=${1:-dev}
echo "Creating split networking/compute environments $STACK-net and $STACK-vm"
echo "... set up networking stack"
set -x
aws cloudformation create-stack --stack-name $STACK-net \
  --template-body file://network.yaml
set +x
echo "... waiting for networking stack to be ready"
aws cloudformation wait stack-create-complete --stack-name $STACK-net
echo "... set up compute stack"
set -x
aws cloudformation create-stack --stack-name $STACK-vm \
  --template-body file://compute.yaml \
  --parameters \
      ParameterKey=SSHKey,ParameterValue=test_key \
      ParameterKey=AMI,ParameterValue=ami-0dd655843c87b6930 \
      ParameterKey=NetStack,ParameterValue=$STACK-net \
  --tags Key=Stack,Value=$STACK-vm