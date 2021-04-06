variable "name" {}
variable "data" {}

locals {
  subnet_count = try(var.data.subnets,1)
  subnets = {
    for count in range(local.subnet_count) :
      format("%s_%02d",var.name,count + 1) => {
        prefix = cidrsubnet(var.data.prefix,8,count+2)
      }
  }
  tgw_prefix = cidrsubnet(var.data.prefix,8,1)
}

resource "aws_vpc" "vpc" {
  tags = {
    Name = var.name
  }
  cidr_block = var.data.prefix
}

output "network" {
  value = {
    name = var.name
    prefix = var.data.prefix
    id = aws_vpc.vpc.id
  }
}

output "subnets" {
  value = aws_subnet.subnet
}

output "tgw_subnet" {
  value = aws_subnet.tgw
}

resource "aws_subnet" "subnet" {
  for_each = local.subnets
  tags = {
    Name = each.key
  }
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value.prefix
}

resource "aws_subnet" "tgw" {
  tags = {
    Name = format("%s_tgw",var.name)
  }
  vpc_id = aws_vpc.vpc.id
  cidr_block = local.tgw_prefix
}
