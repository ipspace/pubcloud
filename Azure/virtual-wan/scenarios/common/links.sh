#!/bin/bash
#
# Create symbolic links in new scenario directory
#
rm -f variables_vhub.tf variables_testbed.tf data_vhub.tf data_vnet.tf
ln -s -v ../../vhub/variables.tf variables_vhub.tf
ln -s -v ../../testbed/variables.tf variables_testbed.tf
ln -s -v ../common/data_vhub.tf .
ln -s -v ../common/data_vnet.tf .
