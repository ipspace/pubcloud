#!/bin/bash
#
set -e
if [ ! -z "$HERE" ]; then
  cd $HERE
fi
. setup.sh
echo "Installing Ansible"
run sudo apt-get $QUIET install software-properties-common
if [ ! -e /etc/apt/sources.list.d/ansible-ubuntu-ansible-bionic.list ]; then
  echo "... adding Ansible repository"
  run sudo apt-add-repository --yes --update ppa:ansible/ansible
fi
echo "... installing Ansible packages"
run sudo apt-get $QUIET install ansible
#
if $USE_AWS; then
  echo "... installing AWS Python modules"
  sudo pip $QUIET install --upgrade boto
fi
#
if $USE_AZURE; then
  echo "... installing Azure Python modules"
  sudo pip $QUIET install --upgrade 'ansible[azure]'
fi
