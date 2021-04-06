# AWS Transit Gateway Testbed

The Terraform configuration in this directory creates a set of virtual networks and virtual machines needed to test AWS Transit Gateway.

The networks and virtual machines are created in a single AWS region specified in **regions** parameter in **variables.tf**. 

The list of virtual networks is defined in the **networks** parameter. It's a map of networks (key = network name); each network is defined with these parameters:

* **region**: index into region table (0 = first region, don't change)
* **subnets**: number of user subnets in the virtual network
* **vm**: deploy a test virtual machine in the first subnet of the virtual network.

WARNING: Virtual machines are deployed when the **deploy_vm** parameter is set to **true**. You could change it in the configuration file, or set it with `-var deploy_vm=true` CLI parameter.

## Usage

* Initialize the Terraform data files (if needed) with **terraform init**
* (Optional) Build a deployment plan with **terraform plan**
* Deploy the infrastructure with **terraform apply** (without virtual machines) or **terraform apply -var deploy_vm=true** if you want to create the test virtual machines

For the extra brave:

* Skip the deployment plan;
* Auto-approve changes with **terraform apply -auto-approve**
