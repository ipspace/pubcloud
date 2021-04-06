variable "name" {}
variable "subnet_id" {}
variable "ssh_key" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name = var.ssh_key

  tags = {
    Name = var.name
  }
}

output "vm" {
  value = {
    name = var.name
    id = aws_instance.vm.id
  }
}

output "ip" {
  value = {
    public_dns = aws_instance.vm.public_dns
    public_ip  = aws_instance.vm.public_ip
    private    = aws_instance.vm.private_ip
  }
}
