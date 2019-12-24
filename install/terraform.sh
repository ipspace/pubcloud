#!/bin/bash
#
set -e
if [ -e /usr/local/bin/terraform ]; then
  echo "Already installed: $(terraform -v)"
else
  TFVER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
  TFPATH=https://releases.hashicorp.com/terraform/${TFVER}/terraform_${TFVER}_linux_amd64.zip
  echo "Installing Terraform version $TFVER from $TFPATH"
  cd /tmp
  rm -f terraform*
  wget $QUIET $TFPATH
  unzip $QUIET terraform*
  sudo mv terraform /usr/local/bin
  rm -f terraform*
fi
