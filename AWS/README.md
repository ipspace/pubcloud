# AWS provisioning and automation examples

The subdirectories contain numerous AWS provisioning and automation examples. In all cases
the end result is the same:

* VPC with custom CIDR block;
* One or more subnets within that VPC;
* Internet gateway attached to the VPC
* Custom route table with default route pointing to the Internet gateway
* Security group(s) permitting SSH, HTTP and HTTPS access from any IP address
* EC2 t2.micro instance running in the public subnet

Examples use four different tools:

* Ansible playbooks
* Bash scripts
* CloudFormation templates
* Terraform configuration files
