variable "name" {}
variable "net" {}
variable "subnet_id" {}
variable "rg" {}
variable "location" {}

resource "azurerm_public_ip" "public_ip" {
  name = format("PUB_%s",var.name)
  location = var.location
  resource_group_name = var.rg
  allocation_method = "Static"
}

resource "azurerm_network_interface" "nic" {
  name = format("NIC_%s",var.name)
  location = var.location
  resource_group_name = var.rg
  enable_ip_forwarding = true

  ip_configuration {
    name = format("NIC_CONF_%s",var.name)
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name = var.name
  location = var.location
  resource_group_name = var.rg
  network_interface_ids = [ azurerm_network_interface.nic.id ]
  vm_size = var.vm_size

  os_profile {
    computer_name = replace(var.name,"_","-")
    admin_username = var.admin_user
  }

  storage_os_disk {
    name = "DISK_${var.name}"
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
      path = "/home/${var.admin_user}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
}

output "vm" {
  value = azurerm_virtual_machine.vm.name
}

output "ip" {
  value = {
    public = azurerm_public_ip.public_ip.ip_address
    private = azurerm_network_interface.nic.private_ip_address
  }
}
