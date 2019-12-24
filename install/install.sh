#!/bin/bash
set -e
#
# Get full path of script directory
#
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. $HERE/setup.sh
#
echo "Running additional installation scripts from $HERE"
. $HERE/system.sh
. $HERE/terraform.sh
. $HERE/ansible.sh
if $USE_AZURE; then
  . $HERE/azure-cli.sh
fi
echo
echo "Installation complete"