# variables for main.tf

data "aws_vpc" "N1" {
  tags = {
    Name = "N1"
  }
}

data "aws_subnet" "N1_tgw" {
  tags = {
    Name = "N1_tgw"
  }
  vpc_id = data.aws_vpc.N1.id
}

data "aws_vpc" "N2" {
  tags = {
    Name = "N2"
  }
}

data "aws_subnet" "N2_tgw" {
  tags = {
    Name = "N2_tgw"
  }
  vpc_id = data.aws_vpc.N2.id
}

data "aws_vpc" "N3" {
  tags = {
    Name = "N3"
  }
}

data "aws_subnet" "N3_tgw" {
  tags = {
    Name = "N3_tgw"
  }
  vpc_id = data.aws_vpc.N3.id
}
