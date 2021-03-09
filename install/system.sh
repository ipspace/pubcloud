#!/bin/bash
#
set -e
echo "Installing system packages"
echo "... remove Debian preconfigure functionality"
sudo rm -f /etc/apt/apt.conf.d/70debconf
if $FLAG_UPDATE; then
  echo "... update installed software to latest release (might take a long time)"
  sudo apt-get $QUIET update
fi
#
# Install missing packages
#
echo "... install missing packages (pretty long operation)"
run sudo apt-get $QUIET install python3-setuptools ifupdown python3-pip unzip
echo "... install nice-to-have packages"
run sudo apt-get $QUIET install git ack-grep jq tree sshpass colordiff
echo "... install nice-to-have Python modules"
sudo pip3 install $QUIET jmespath
#
if $USE_AWS; then
  echo "... installing AWS Python modules"
  sudo pip3 $QUIET install --upgrade awscli
fi
