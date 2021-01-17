# compute terraform file to deploy instances in created subnets

provider "aws" {
    region = var.region
}

# search for the AMI ID based on the region, owner and name

data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal*"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

# deploy instances in the subnets

resource "aws_instance" "instanceA" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnetA_id
    availability_zone = "${var.region}a"
    vpc_security_group_ids = var.security_id
    associate_public_ip_address = true
    key_name = var.ssh_key

    connection {
        host = self.public_ip
        user = "ubuntu"
        type = "ssh"
        private_key = file(var.key_loc)
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "sudo apt-get install -y apache2"
        ]

    }

    tags = {
        Name = "InstanceA(${var.region}a)"
        Type = "webserver"
    }
}

resource "aws_instance" "instanceB" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnetB_id
    availability_zone = "${var.region}b"
    vpc_security_group_ids = var.security_id
    associate_public_ip_address = true
    key_name = var.ssh_key

    connection {
        host = self.public_ip
        user = "ubuntu"
        type = "ssh"
        private_key = file(var.key_loc)
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y upgrade",
            "sudo apt-get install -y apache2"
        ]

    }

    tags = {
        Name = "InstanceB(${var.region}b)"
        Type = "webserver"
    }
}