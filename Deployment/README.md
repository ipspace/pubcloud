# Deploying Application Infrastructure in Public Clouds

This directory contains automation examples you can use to create your own public cloud application infrastructure deployment recipes (or whatever you want to call them).

The deployment examples:

* Configure a virtual network and subnets
* Connect the virtual network to the global Internet
* Create security groups
* Deploy virtual machines

The subdirectories are organized as follows:

* [AWS](AWS) directory contains Ansible playbooks, Bash scripts,  CloudFormation templates, and Terraform configuration files.
* [Azure](Azure) directory contains Ansible playbooks, CLI examples, Resource Manager template, and Terraform configuration files.
* [VM-Provisioning](VM-Provisioning) directory contains an Ansible playbook that uses dynamic EC2 inventory to provision web servers.
