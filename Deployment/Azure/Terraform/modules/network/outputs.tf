# outputs of network module

output "resourcegroup" {
	description = "name of resource group for VM"
	value = azurerm_resource_group.tf_rg.name
}

output "nicID" {
	description = "id of network interface for VM"
	value = [ azurerm_network_interface.tf_nic.id ]
}

output "public_ip" {
	value = azurerm_public_ip.tf_public_ip.ip_address
	description = "public IP of WebVM for access over CLI"
}