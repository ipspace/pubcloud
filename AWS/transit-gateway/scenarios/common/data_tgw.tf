# variables for main.tf

data "aws_ec2_transit_gateway" "tgw" {
  tags = {
    Name = "tgw"
  }
}
