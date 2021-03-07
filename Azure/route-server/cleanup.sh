#!/bin/bash
RG=`cat ~/.rg 2>/dev/null`
RG=${RG:-rt}
echo "Cleanup route server in resource group $RG"
#
time az network routeserver peering delete \
  --routeserver RouteServer \
  --resource-group $RG \
  --name Web_BGP_Peering -y
#
time az network routeserver delete \
  --name RouteServer \
  --resource-group $RG -y
