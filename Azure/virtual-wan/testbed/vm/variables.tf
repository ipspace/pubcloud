# VM variables

variable "admin_user" {
  type = string
  default = "azure"
}

variable "vm_size" {
  type = string
  default = "Standard_B1s"
}

variable "image_publisher" {
  type = string
  default = "Canonical"
}

variable "image_offer" {
  type = string
  default = "UbuntuServer"
}

variable "image_sku" {
  type = string
  default = "18.04-LTS"
}

variable "image_version" {
  type = string
  default = "latest"
}
