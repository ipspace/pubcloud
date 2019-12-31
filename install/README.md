# Install Your Development Environment

This directory contains installation scripts that will help you set up a
Ubuntu-based development environment. You could use them together with
**Vagrantfile** from the top-level directory to build a simple Vagrant-based
setup.

* **setup.sh** - sets the environment variables. Modify it to suit your requirements
* **install.sh** - main installation scripts. Sets the environment variables using **setup.sh**
  and calls other installation scripts

Component installation scripts:

* **system.sh** - installs system and Python utilities. Also installs AWS CLI if you plan to
  work with AWS.
* **ansible.sh** - installs Ansible and its dependencies, including libraries needed to
  manage AWS or Azure with Ansible
* **azure-cli.sh** - installs Azure CLI
* **terraform.sh** - installs Terraform
