#!/bin/bash
#
if $FLAG_UPDATE; then
  echo "Update installed software to latest release (might take a long time)"
  sudo apt-get $QUIET update
fi
#
# Install missing packages
#
echo "Install missing packages (also a pretty long operation)"
run sudo apt-get $QUIET install python-setuptools ifupdown python-pip unzip
echo "Install nice-to-have packages"
run sudo apt-get $QUIET install git ack-grep jq tree sshpass colordiff
