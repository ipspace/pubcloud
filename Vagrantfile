# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.box_check_update = false

  ["vmware_workstation", "vmware_fusion"].each do |vmware_provider|
    config.vm.provider(vmware_provider) do |vmware|
      vmware.whitelist_verified = true
    end
  end

  config.vm.define "linux" do |linux|
    linux.vm.host_name = "linux"
    linux.vm.network "private_network", ip: "172.16.1.12"
    linux.vm.provision "shell", inline: "/vagrant/install/install.sh"
  end
end
