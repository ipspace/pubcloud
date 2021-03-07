#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-Test}
echo "Create AppNet and subnets NVA and Internal in resource group $RG"
#
set -x
#
# Create VNet and first subnet
#
az network vnet create \
  --resource-group $RG \
  --name AppNet \
  --address-prefixes 172.16.0.0/16 \
  --subnet-name NVA \
  --subnet-prefixes 172.16.1.0/24
#
# Create second subnet
#
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name AppNet \
  --name Internal \
  --address-prefixes 172.16.2.0/24
