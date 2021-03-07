#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-Test}
echo "Create two virtual machines (one per subnet) in resource group $RG"
if [ $1 ]; then
  echo "Public IP address name of second VM: $1"
fi
#
set -x
#
az vm create \
 --resource-group $RG \
 --name NVA_1 \
 --tags role=NVA \
 --image UbuntuLTS \
 --vnet-name AppNet \
 --subnet NVA \
 --admin-username azure \
 --ssh-key-value ~/.ssh/id_rsa.pub \
 --public-ip-address NVA_1_Public
#
az vm create \
 --resource-group $RG \
 --name NVA_2 \
 --tags role=NVA \
 --image UbuntuLTS \
 --vnet-name AppNet \
 --subnet NVA \
 --admin-username azure \
 --ssh-key-value ~/.ssh/id_rsa.pub \
 --public-ip-address NVA_2_Public
#
az vm create \
 --resource-group $RG \
 --name Backend \
 --image UbuntuLTS \
 --vnet-name AppNet \
 --subnet Internal \
 --admin-username azure \
 --ssh-key-value ~/.ssh/id_rsa.pub \
 --public-ip-address "$1"
