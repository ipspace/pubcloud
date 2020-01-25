#!/bin/bash
#
# Deploy appstack template and supply default SSH public key as a parameter
#
PUBKEY=$(cat ~/.ssh/id_rsa.pub)
az group create --name RM --location westeurope
az group deployment create --name Test \
  --resource-group RM \
  --template-file appstack.json \
  --parameters ssh-public-key="$PUBKEY"
