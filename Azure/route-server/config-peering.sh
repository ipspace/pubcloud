#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-rt}
echo "Create route server peerings in resource group $RG"
#
nva_ip=$(az vm show -g $RG -n NVA_1 -d --query 'privateIps' -o tsv)
echo "NVA_1 Private IP: $nva_ip"
#
set -x
time az network routeserver peering create \
  --routeserver RouteServer \
  --resource-group $RG \
  --peer-ip $nva_ip --peer-asn 65000 \
  --name NVA_1
set+x
#
nva_ip=$(az vm show -g $RG -n NVA_2 -d --query 'privateIps' -o tsv)
echo "NVA_2 Private IP: $nva_ip"
#
set -x
time az network routeserver peering create \
  --routeserver RouteServer \
  --resource-group $RG \
  --peer-ip $nva_ip --peer-asn 65000 \
  --name NVA_2
