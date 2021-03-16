#!/bin/bash
#
az network vhub route-table list \
  --resource-group GLOBAL \
  --vhub-name VH_R1
#
az network vhub route-table show \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --name defaultRouteTable
#
rtid=$(az network vhub route-table show \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --name defaultRouteTable \
  --query "id" -o tsv
)
az network vhub get-effective-routes \
  --name VH_R1 \
  --resource-group GLOBAL \
  --resource-id $rtid \
  --resource-type RouteTable
