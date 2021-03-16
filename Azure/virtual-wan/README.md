# Azure Virtual WAN Scenarios

This directory contains numerous Azure Virtual WAN scenarios, from simple _connect everything to default route_ topology to multi-hub multi-VRF scenarios.

One of the simple scenarios is implemented with Azure CLI commands -- you'll find them group in Bash scripts in the [CLI](CLI) directory.

Other scenarios use several layers of Terraform configurations to make it easier to deploy the baseline infrastructure and then test individual scenarios:

* Deploy the virtual networks an virtual machines from the [testbed](testbed) directory;
* Deploy virtual WAN and virtual hubs from the [vhub](vhub) directory;
* Test individual connectivity scenarios found in [scenarios](scenarios) tree.
