#!/bin/bash
#
# Connect VNETs to default route table of a single hub
#
time az network vhub connection create \
  --name CN_R1_T1_1 \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --remote-vnet R1_T1_1
#
time az network vhub connection create \
  --name CN_R1_T1_2 \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --remote-vnet R1_T1_2
#
time az network vhub connection create \
  --name CN_R2_T1_1 \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --remote-vnet R2_T1_1
#
time az network vhub connection create \
  --name CN_R2_T1_2 \
  --resource-group GLOBAL \
  --vhub-name VH_R1 \
  --remote-vnet R2_T1_2 \
  --address-prefixes "172.19.1.0/24,172.19.2.0/24,172.22.1.0/24" \
  --next-hop "172.19.1.2"
