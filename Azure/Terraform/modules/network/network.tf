# network part of Azure infrastructure deploying resource group, vnet, subnets, nic ...

######################
#create resource group
######################

resource "azurerm_resource_group" "tf_rg" {
	name = var.resourcegroup_name
	location = var.location
}

########################
# create virtual network
########################

resource "azurerm_virtual_network" "tf_vnet" {
	name = var.network_name
	location = var.location
	resource_group_name = azurerm_resource_group.tf_rg.name
	address_space = var.network_ip
}

###############
#create subnets
###############

resource "azurerm_subnet" "tf_public_subnet" {
	name = var.public_sub_name
	resource_group_name = azurerm_resource_group.tf_rg.name
	virtual_network_name = azurerm_virtual_network.tf_vnet.name
	address_prefix = var.public_sub_address
}

resource "azurerm_subnet" "tf_private_subnet" {
	name = var.private_sub_name
	resource_group_name = azurerm_resource_group.tf_rg.name
	virtual_network_name = azurerm_virtual_network.tf_vnet.name
	address_prefix = var.private_sub_address
}

###################
#create route table
###################

resource "azurerm_route_table" "tf_RT" {
	name = var.rt_name
	location = var.location
	resource_group_name = azurerm_resource_group.tf_rg.name

	route {
		name = var.route_name
		address_prefix = "0.0.0.0/0"
		next_hop_type =  "None"
	}
}

#########################
#associate RT with subnet
#########################

resource "azurerm_subnet_route_table_association" "tf_RT_associaton" {
	subnet_id = azurerm_subnet.tf_private_subnet.id
	route_table_id = azurerm_route_table.tf_RT.id
}

#################
#create public ip
#################

resource "azurerm_public_ip" "tf_public_ip" {
	name = var.pub_ip_name
	location = var.location
	resource_group_name = azurerm_resource_group.tf_rg.name
	allocation_method = var.pub_ip_method
}

######################
#create security group
######################

resource "azurerm_network_security_group" "tf_sg" {
	name = var.sg_name
	location = var.location
	resource_group_name = azurerm_resource_group.tf_rg.name

	security_rule {
		name = var.ssh_rule_name
		priority = 101
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "*"
		destination_port_range = "22"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}

	security_rule {
		name = var.http_rule_name
		priority = 102
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "80"
		destination_port_range = "80"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}

	security_rule {
		name = var.https_rule_name
		priority = 103
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "443"
		destination_port_range = "443"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}
}

##############################
#create network interface card
##############################

resource "azurerm_network_interface" "tf_nic" {
	name = var.nic_name
	location = var.location
	resource_group_name = azurerm_resource_group.tf_rg.name
	network_security_group_id = azurerm_network_security_group.tf_sg.id

	ip_configuration {
		name = var.nic_ip_conf_name
		subnet_id = azurerm_subnet.tf_public_subnet.id
		public_ip_address_id = azurerm_public_ip.tf_public_ip.id
		private_ip_address_allocation = "Dynamic"
	}
}
