#!/bin/bash
#
# Validate appstack template (using default SSH public key as a parameter)
#
PUBKEY=$(cat ~/.ssh/id_rsa.pub)
az group deployment validate \
  --resource-group RM \
  --template-file appstack.json \
  --parameters ssh-public-key="$PUBKEY"
