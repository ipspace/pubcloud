#!/bin/bash
#
set -x
az group create --location westeurope --name GLOBAL
#
az network vnet create \
  --resource-group GLOBAL \
  --location westeurope \
  --name R1_T1_1 \
  --address-prefixes 172.16.0.0/16 \
  --subnet-name R1_T1_1A \
  --subnet-prefixes 172.16.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location westeurope \
  --name R1_T1_2 \
  --address-prefixes 172.17.0.0/16 \
  --subnet-name R1_T1_1A \
  --subnet-prefixes 172.17.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location westeurope \
  --name R1_T2 \
  --address-prefixes 10.1.0.0/16 \
  --subnet-name R1_T2A \
  --subnet-prefixes 10.1.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location westeurope \
  --name R1_SHARED \
  --address-prefixes 192.168.0.0/24 \
  --subnet-name R1_SHARED \
  --subnet-prefixes 192.168.0.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location northeurope \
  --name R2_T1_1 \
  --address-prefixes 172.18.0.0/16 \
  --subnet-name R2_T1_1A \
  --subnet-prefixes 172.18.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location northeurope \
  --name R2_T1_2 \
  --address-prefixes 172.19.0.0/16 \
  --subnet-name R2_T1_2A \
  --subnet-prefixes 172.19.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location northeurope \
  --name R2_T2 \
  --address-prefixes 10.2.0.0/16 \
  --subnet-name R1_T2A \
  --subnet-prefixes 10.2.1.0/24
#
az network vnet create \
  --resource-group GLOBAL \
  --location northeurope \
  --name R2_SHARED \
  --address-prefixes 192.168.1.0/24 \
  --subnet-name R2_SHARED \
  --subnet-prefixes 192.168.1.0/24
