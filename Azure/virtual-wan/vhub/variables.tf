# variables for main.tf

variable "vhub_rg_name" {
  type = string
  default = "VHUB"
}

variable "vwan_name" {
  type = string
  default = "WAN"
}

variable "hubs" {
  type = list
  default = [
    { region = "westeurope",
      name   = "vHub_WE"
      prefix = "192.168.200.0/24" },
    { region = "northeurope",
      name   = "vHub_NE"
      prefix = "192.168.201.0/24" }
  ]
}
