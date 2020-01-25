# computation part of Azure infrastructure deploying webVM

resource "azurerm_virtual_machine" "tf_vm" {
	name = var.vm_name
	location = var.location
	resource_group_name = var.rg_name
	network_interface_ids = var.nic_id
	vm_size = var.vm_size
	
	os_profile {
		computer_name = "myWebVM"
		admin_username = "demouser"
	}
	
	storage_os_disk {
		name = "myOsDisk"
		create_option = "FromImage"
	}
	
	storage_image_reference {
		publisher = var.image_publisher
		offer = var.image_offer
		sku = var.image_sku
		version = var.image_version
	}
	
	os_profile_linux_config {
		disable_password_authentication = true
		ssh_keys {
			path = "/home/demouser/.ssh/authorized_keys"
			key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqFhIxpbql8i9VCunUBRLc7pBz4yvg9x/gZrX41XygIS1J2skkQIueYJQO+aSMBKyQnQtJGgH+PUxcMcb281pga7FK1iL6kFBEeMOH23SjHmWEqjY4SYQZEBWkcwPrqhiXsk01N2BR8eSRZqTh6XEZ8QZrEXxftvxum+pfP3YUpLOaQI5+rGmXCEnbCANTfbCwxXVJrMKrmtIvfyWpe/9QbCVIvNDyM10u9pvxyN/o1ifXq+0nvCvUFmgXy2Pa7WUcAerFy9WR55Kj/pD/TV9DPWB0/A15iDD7i14bKpkeA6C2QLWX7vpiDc/FfBORz2Oy5ea/SXUpdTKSHFQ4FdRHRTaOwagulWw+nFzU7OWjHXIGcnEmR9nu1M4euG4TWvwpjRoPiB6GQ0P79vTIKfmRlBcTax399WQXtOvxoDvn9FSeC7eIRDsf97P2eiF5oSYjGcmj2ANVxSIZkOtl+GoJrq4Ob0Q+7isx0h0bo/GI36pdrESiyYStHR49GUwm36D6tAg//zkrdfU5vQLGyBQpeoeMtr0Myomo5WneLQifHvJB+jOH+w7Y8rfT/6q2BwCmOwEIpIPZg5qdXz79nvfMmCoOENIyGINR4VMPIEJstB0Wg0yjsJ+GsSJbWpFsiRSHaKNM1SiMClAK/jN8VTBN+pLT+Dbn6JHKcXG2qvnxvw== vagrant@vagrant"
		}
	}
	
	delete_os_disk_on_termination = true
	delete_data_disks_on_termination = true
}