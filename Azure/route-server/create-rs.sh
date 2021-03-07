#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-rt}
echo "Create route server in resource group $RG"
#
set -x
#
# Create route server subnet
#
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name AppNet \
  --name RouteServerSubnet \
  --address-prefix 172.16.3.0/24
#
# Get subnet ID
#
set +x
subnet_id=$(az network vnet subnet show \
  --name RouteServerSubnet \
  --vnet-name AppNet \
  --resource-group $RG \
  --query id -o tsv)
echo "Subnet ID: $subnet_id"
set -x
#
# Create route server
#
time az network routeserver create \
  --name RouteServer \
  --resource-group $RG \
  --hosted-subnet $subnet_id
