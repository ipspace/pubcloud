# variables for main.tf

variable "testbed_rg_name" {
  type = string
  default = "TESTBED"
}

variable deploy_vm {
  type = bool
  default = false
}

variable "regions" {
  type = list
  default = ["westeurope","northeurope"]
}

variable "networks" {
  type = map
  default = {
    R1_T1_1 = {
      region = 0
      subnets = 2
      prefix = "172.16.0.0/16"
      vm = true
    }
    R1_T1_2 = {
      region = 0
      subnets = 2
      prefix = "172.17.0.0/16"
    }
    R1_SHARED = {
      region = 0
      prefix = "192.168.0.0/24"
      vm = true
    }
    R1_T2 = {
      region = 0
      subnets = 2
      prefix = "10.2.0.0/16"
      vm = true
    }
    R2_T1_1 = {
      region = 0
      subnets = 2
      prefix = "172.18.0.0/16"
    }
    R2_T1_2 = {
      region = 0
      subnets = 2
      prefix = "172.19.0.0/16"
      vm = true
    }
    R2_SHARED = {
      region = 0
      prefix = "192.168.1.0/24"
    }
    R2_T2 = {
      region = 0
      subnets = 2
      prefix = "10.3.0.0/16"
    }
  }
}
