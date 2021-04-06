# AWS Transit Gateway Scenarios

This directory contains AWS Transit Gateway scenarios, currently limited to simple _connect three VPCs_ one.

Scenarios use two layers of Terraform configurations to make it easier to deploy the baseline infrastructure and then test individual scenarios:

* Deploy the baseline infrastructure (VPC, subnets, VMs, TGW) from the [testbed-setup](testbed-setup) directory;
* Test individual connectivity scenarios found in [scenarios](scenarios) tree.
