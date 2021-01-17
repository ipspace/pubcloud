#!/bin/bash
#
TEMPLATE=${1:-stack.yaml}
STACK=${2:-dev}
echo "Creating CloudFormation stack $STACK from $TEMPLATE"
set -x
aws cloudformation create-stack --stack-name $STACK \
  --template-body file://$TEMPLATE \
  --parameters \
      ParameterKey=SSHKey,ParameterValue=test_key \
      ParameterKey=AMI,ParameterValue=ami-0dd655843c87b6930 \
  --tags Key=Stack,Value=$STACK