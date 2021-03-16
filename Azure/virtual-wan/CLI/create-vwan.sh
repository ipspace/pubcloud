#!/bin/bash
#
# Create virtual WAN and hubs in US East and US West
#
set +x
time az network vwan create --name WAN --resource-group GLOBAL
#
time az network vhub create \
  --address-prefix 192.168.200.0/24 \
  --name VH_R1 \
  --resource-group GLOBAL \
  --location westeurope \
  --vwan WAN
#
time az network vhub create \
  --address-prefix 192.168.201.0/24 \
  --name VH_R2 \
  --resource-group GLOBAL \
  --location northeurope \
  --vwan WAN
