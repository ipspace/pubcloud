# compute terraform file to deploy instances in created subnets

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

resource "aws_instance" "webserver" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    availability_zone = "${var.region}a"
    vpc_security_group_ids = var.security_group_id
    associate_public_ip_address = true
    source_dest_check = false
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
        Name = var.instance_name_tag
        Type = "webserver"
        Role = var.instance_role_tag
    }
}

#outputs needed to later set up the transit gateway ip multicast in AWS CLI
output "instance_nic_id" {
    value = aws_instance.webserver.primary_network_interface_id
}