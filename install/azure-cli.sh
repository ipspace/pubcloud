#!/bin/bash
#
set -e
if [ ! -z "$HERE" ]; then
  cd $HERE
fi
. setup.sh
echo "Installing Azure CLI"
echo "... installing Microsoft signing key"
run sudo apt-get $QUIET install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
echo "... adding Azure repository"
if [ ! -e /etc/apt/sources.list.d/azure-cli.list ]; then
  AZ_REPO=$(lsb_release -cs)
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
      sudo tee /etc/apt/sources.list.d/azure-cli.list
  run sudo apt-get $QUIET update
fi
echo "... installing Azure CLI"
run sudo apt-get $QUIET install azure-cli
