#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-Test}
echo "Create route table in resource group $RG"
#
set -x
#
# Create route table
#
az network route-table create \
  --resource-group $RG \
  --name Private
#
# Create discard default route
#
az network route-table route create \
  --resource-group $RG \
  --route-table-name Private \
  --name DropDefault \
  --address-prefix "0.0.0.0/0" --next-hop-type None
#
# Apply route table to private subnet
#
az network vnet subnet update \
  --resource-group $RG \
  --vnet-name AppNet --name Internal \
  --route-table Private
