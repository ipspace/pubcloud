#!/bin/bash
#
# Connect VNETs to default route table of a single hub
#
time az network vhub connection delete \
  --name CN_R1_T1_1 \
  --resource-group GLOBAL \
  --vhub-name VH_R1
#
time az network vhub connection delete \
  --name CN_R1_T1_2 \
  --resource-group GLOBAL \
  --vhub-name VH_R1
#
time az network vhub connection delete -y \
  --name CN_R2_T1_1 \
  --resource-group GLOBAL \
  --vhub-name VH_R1
#
time az network vhub connection delete -y \
  --name CN_R2_T1_2 \
  --resource-group GLOBAL \
  --vhub-name VH_R1
