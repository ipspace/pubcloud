# variables for main.tf

variable "location" {
	type = string
	default = "westeurope"
}

variable "rg_name" {
  type = string
  default = "terraform_demo"
}
