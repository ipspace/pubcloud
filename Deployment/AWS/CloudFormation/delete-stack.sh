#!/bin/bash
#
STACK=${1:-dev}
echo "Deleting CloudFormation stack $STACK"
set -x
aws cloudformation delete-stack --stack-name $STACK
