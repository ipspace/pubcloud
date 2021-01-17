# compute file deploying ec2 instances placed in vpc/subnets created with network.tf

#get appropriate AMI ID

data "aws_ami" "ubuntu" {
    owners = ["099720109477"] #canonical user ID
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

# deploy a jump host / Bastion

resource "aws_instance" "bastion" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	subnet_id = var.pub_sub1_id
	vpc_security_group_ids = var.bastion_sg_id
	associate_public_ip_address = true
	key_name = var.ssh_key

	tags = {
		Name = "Bastion Host"
		type = "bastionhost"
	}

	connection {
		host = self.public_ip
		user = var.instance_user
		type = "ssh"
		private_key = file(var.key_loc)
	}

	provisioner "remote-exec" {
		inline = [
			"sudo wget https://raw.githubusercontent.com/MihaMarkocic/cloudservices/master/AWS/web_application_firewall/init_files/bastion_init.sh",
			"sudo chmod 774 bastion_init.sh",
			"sudo ./bastion_init.sh"
		]
	}
}

# deploy webserver in public subnet 1

resource "aws_instance" "webserver1" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	subnet_id = var.pub_sub1_id
	vpc_security_group_ids = var.webserver_sg_id
	associate_public_ip_address = true
	key_name = var.ssh_key
	
	tags = {
		Name = "Webserver1"
		type = "webserver"
	}

	connection {
		bastion_host = aws_instance.bastion.public_ip
		bastion_private_key = file(var.key_loc)
		host = self.private_ip
		user = var.instance_user
		type = "ssh"
		private_key = file(var.key_loc)
	}
	
	provisioner "remote-exec" {
		inline = [
			"sudo wget https://raw.githubusercontent.com/MihaMarkocic/cloudservices/master/AWS/web_application_firewall/init_files/webserver_init.sh",
			"sudo chmod 774 webserver_init.sh",
			"sudo ./webserver_init.sh ${aws_instance.webserver1.tags.Name}"
		]
	}
}

# deploy webserver in public subnet 2

resource "aws_instance" "webserver2" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	subnet_id = var.pub_sub2_id
	vpc_security_group_ids = var.webserver_sg_id
	associate_public_ip_address = true
	key_name = var.ssh_key
	
	tags = {
		Name = "Webserver2"
		type = "webserver"
	}

	connection {
		bastion_host = aws_instance.bastion.public_ip
		bastion_private_key = file(var.key_loc)
		host = self.private_ip
		user = var.instance_user
		type = "ssh"
		private_key = file(var.key_loc)
	}
	
	provisioner "remote-exec" {
		inline = [
			"sudo wget https://raw.githubusercontent.com/MihaMarkocic/cloudservices/master/AWS/web_application_firewall/init_files/webserver_init.sh",
			"sudo chmod 774 webserver_init.sh",
			"sudo ./webserver_init.sh ${aws_instance.webserver2.tags.Name}"
		]
	}
}

# deploy database in private subnet

resource "aws_instance" "database" {
	ami = data.aws_ami.ubuntu.id
	instance_type = var.instance_type
	subnet_id = var.prvt_sub1_id
	vpc_security_group_ids = var.database_sg_id
	associate_public_ip_address = false
	key_name = var.ssh_key
	
	tags = {
		Name = "Database"
		type = "database"
	}
}