# compute.tf deploying ec2 instance placed in already existing vpc (network.tf)

# create ec2 instance
resource "aws_instance" "Web_VM" {
	ami = var.instance_ami
	instance_type = var.instance_type
	subnet_id = var.vpc_subnet_id
	availability_zone = var.ec2_AZ
	vpc_security_group_ids = var.ec2_security_group_id
	associate_public_ip_address = true
	key_name = var.SSH_key
	
tags = {
	Name = "Ubuntu Virtual Machine"
}

}