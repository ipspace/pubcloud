# Automation Demo Script

Prepare for the demos

* Bring up Vagrant Ubuntu VM
* Log into default Vagrant account
* Set up the environment

```
. /vagrant/install/.prompt
. .aws/setup
```

## Create a single object (VPC)

### CLI

Execute in CLI directory

```
less steps/10-create-vpc.sh
steps/10-create-vpc.sh
steps/10-create-vpc.sh
aws ec2 describe-vpcs
aws_vpc
aws_vpc --output table
```

### Ansible

Execute in Ansible directory

```
cat steps/20-create-vpc.yaml
ansible-playbook steps/20-create-vpc.yaml
ansible-playbook steps/20-create-vpc.yaml -e state=absent
export ANSIBLE_STDOUT_CALLBACK=yaml
ansible-playbook steps/20-create-vpc.yaml -v
```

### CloudFormation

Execute in CloudFormation directory

```
aws_vpc
cat steps/20-create-vpc.yaml
aws cloudformation create-stack --stack-name test --template-body file://steps/20-create-vpc.yaml
aws cloudformation describe-stacks
aws cloudformation wait stack-create-complete
aws_vpc
aws ec2 describe-vpcs
aws cloudformation delete-stack --stack-name test

## Create Object Hierarchy

### CLI

Execute in CLI directory

```
less steps/20-create-subnet.sh
steps/20-create-subnet.sh
steps/10-create-vpc.sh
steps/20-create-subnet.sh
```

### Ansible

Prepare for demo in Ansible directory

```
export ANSIBLE_STDOUT_CALLBACK=yaml
ansible-playbook steps/21-create-subnets.yaml -e state=absent
ansible-playbook steps/20-create-vpc.yaml
```

Execute in Ansible directory

```
cat steps/21-create-subnets.yaml
ansible-playbook steps/21-create-subnets.yaml -v
ansible-playbook steps/21-create-subnets.yaml -e state=absent
```

### CloudFormation

Execute in CloudFormation directory

```
aws cloudformation create-stack --stack-name test --template-body file://steps/21-create-subnets.yaml
aws cloudformation describe-stacks
aws cloudformation delete-stack --stack-name test
```
