# AWS Demos

## Create VPC

aws ec2 describe-vpcs
aws ec2 describe-vpcs --query 'Vpcs[].[VpcId,CidrBlock,Tags]'
aws ec2 describe-vpcs --query 'Vpcs[].{id:VpcId,cidr:CidrBlock,name:Tags[?Key==`Name`].Value[]|[0]}'
alias aws_vpc=$'aws ec2 describe-vpcs --query \'Vpcs[].{id:VpcId,cidr:CidrBlock,name:Tags[?Key==`Name`].Value[]|[0]}\''
