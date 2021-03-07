#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-Test}
echo "Install Quagga on NVA VM"
#
set -x
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i nva_azure_rm.yml install-quagga.yml
