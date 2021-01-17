# terraform script to deploy multiple ec2 aws instances

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

resource "aws_instance" "webserver1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instanceType
    subnet_id = var.subnetID
    availability_zone = var.EC2AvailabilityZone
    vpc_security_group_ids = var.securityGroupID
    associate_public_ip_address = true
    key_name = var.sshKey 

    tags = {
        Name = "Webserver1"
        type = "webserver"
    }

    connection {
        host = self.public_ip
        user = var.instanceUser
        type = "ssh"
        private_key = file(var.sshKeyLoc)
    }

    provisioner "remote-exec" {
        inline = ["sudo apt-get -y update"]
    }

    provisioner "local-exec" {
        command = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -u ${var.instanceUser} --private-key ${var.sshKeyLoc} -i ./inventory/aws_ec2.yaml provision_instances.yaml"
    }
}

resource "aws_instance" "webserver2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instanceType
    subnet_id = var.subnetID
    availability_zone = var.EC2AvailabilityZone
    vpc_security_group_ids = var.securityGroupID
    associate_public_ip_address = true
    key_name = var.sshKey 

    tags = {
        Name = "Webserver2"
        type = "webserver"
    }

    connection {
        host = self.public_ip
        user = var.instanceUser
        type = "ssh"
        private_key = file(var.sshKeyLoc)
    }

    provisioner "remote-exec" {
        inline = ["sudo apt-get -y update"]
    }
}

resource "aws_instance" "webserver3" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instanceType
    subnet_id = var.subnetID
    availability_zone = var.EC2AvailabilityZone
    vpc_security_group_ids = var.securityGroupID
    associate_public_ip_address = true
    key_name = var.sshKey 

    tags = {
        Name = "Webserver3"
        type = "webserver"
    }

    connection {
        host = self.public_ip
        user = var.instanceUser
        type = "ssh"
        private_key = file(var.sshKeyLoc)
    }

    provisioner "remote-exec" {
        inline = ["sudo apt-get -y update"]
    }
}

