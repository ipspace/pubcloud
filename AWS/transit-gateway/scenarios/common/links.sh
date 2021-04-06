#!/bin/bash
#
# Create symbolic links in new scenario directory
#
rm -f data_tgw.tf data_vpc.tf variables_testbed.tf
ln -s -v ../../testbed-setup/variables.tf variables_testbed.tf
ln -s -v ../common/data_vpc.tf .
ln -s -v ../common/data_tgw.tf .
