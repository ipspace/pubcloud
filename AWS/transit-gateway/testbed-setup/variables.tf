# variables for main.tf

variable deploy_vm {
  type = bool
  default = false
}

variable "regions" {
  type = list
  default = ["us-east-1"]
}

variable "networks" {
  type = map
  default = {
    N1 = {
      region = 0
      subnets = 2
      prefix = "172.16.0.0/16"
      vm = true
    }
    N2 = {
      region = 0
      subnets = 2
      prefix = "172.17.0.0/16"
      vm = true
    }
    N3 = {
      region = 0
      subnets = 2
      prefix = "172.18.0.0/16"
      vm = true
    }
  }
}
